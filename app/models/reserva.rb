# frozen_string_literal: true

# == Schema Information
#
# Table name: reservas
#
#  id          :bigint(8)        not null, primary key
#  aprobado    :boolean          default(TRUE)
#  bloqueo     :boolean          default(FALSE)
#  descripcion :string
#  end_time    :datetime
#  finalidad   :string
#  nombre      :string
#  start_time  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint(8)
#
# Indexes
#
#  index_reservas_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
# rubocop:disable Metrics/ClassLength
class Reserva < ApplicationRecord
  belongs_to :user, optional: false
  has_many :invitados, dependent: :destroy
  accepts_nested_attributes_for :invitados,
                                reject_if: proc { |attributes|
                                             attributes[:nombre].blank? || attributes[:apellido].blank?
                                           },
                                allow_destroy: true

  default_scope { order(start_time: :asc) }

  scope :del_dia, lambda { |reserva|
    where("extract(day from start_time) = ?", reserva.start_time.day)
      .where("extract(month from start_time) = ?", reserva.start_time.month)
      .where("extract(year from start_time) = ?", reserva.start_time.year)
  }

  scope :no_anonimas, lambda {
    includes(:invitados).references(:invitados).where("invitados.anonimo = FALSE")
  }

  scope :esperando_aprobacion, -> { where(aprobado: false) }

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :finalidad, inclusion: { in: FINALIDADES }

  # Si es capacitacion, que tenga nombre y descripcion con las longs correctas
  validates :nombre, :descripcion,
            presence: true,
            if: proc { |reserva| reserva.finalidad == "Evento/capacitación/reunión" }
  validates :nombre,
            length: { minimum: RESERVA_NOMBRE_MIN, maximum: RESERVA_NOMBRE_MAX },
            if: proc { |reserva| reserva.finalidad == "Evento/capacitación/reunión" }
  validates :descripcion,
            length: { minimum: RESERVA_DESCRIPCION_MIN, maximum: RESERVA_DESCRIPCION_MAX },
            if: proc { |reserva| reserva.finalidad == "Evento/capacitación/reunión" }

  # Que termine después de que empiece
  validate :termina_dsp_d_q_empiece
  # Que termine el mismo día que empieza
  validate :empieza_termina_mismo_dia

  # Que sea un día permitido
  validate :cumple_dia

  # Que esté dentro de la franja horaria permitida
  validate :cumple_horario_apertura

  # Que no haya reservas bloqueantes en ese mismo periodo
  validate :check_bloqueos

  # Que no haya más del máximo permitido de ocupaciones
  validate :max_ocupaciones_propias
  validate :max_ocupaciones

  def fecha
    start_time.strftime("%-d/%-m/%-Y")
  end

  def hora_comienzo
    start_time.strftime("%k:%M")
  end

  def hora_fin
    end_time.strftime("%k:%M")
  end

  def ocupaciones
    invitados.count + 1
  end

  # rubocop:disable Metrics/AbcSize
  def nombre_invitados(cuantos=3)
    return "" if invitados.no_anonimos.empty?

    if invitados.no_anonimos.count > 2
      invitados.no_anonimos.order(id: :desc).limit(cuantos).pluck(:nombre).join(", ") + "..."
    elsif invitados.no_anonimos.count > 1
      invitados.no_anonimos.order(id: :desc).all.pluck(:nombre).join(" y ")
    else
      invitados.no_anonimos.order(id: :desc).first.nombre
    end
  end
  # rubocop:enable Metrics/AbcSize

  def solapa_con?(hora_ini, hora_fin)
    if  start_time <  hora_fin && start_time > hora_ini ||
        start_time <= hora_ini && end_time   > hora_ini
      true
    else
      false
    end
  end

  def contenido_en(hora_ini, hora_fin)
    start_time >= hora_ini && end_time <= hora_fin
  end

  private

  def max_ocupaciones
    Reserva.del_dia(self).each do |otra_reserva|
      next if otra_reserva == self
      next unless solapa_con?(otra_reserva.start_time, otra_reserva.end_time)
      next unless ocupaciones + otra_reserva.ocupaciones > MAX_OCUPACIONES

      errors.add(:ocupaciones,
                 "El turno excede la cantidad de lugares porque ya hay otro turno de
                 #{otra_reserva.user.nombre_completo} con #{otra_reserva.ocupaciones}
                 ocupaciones con el que éste se solapa.")
    end
  end

  # rubocop:disable Style/GuardClause
  def max_ocupaciones_propias
    if ocupaciones > MAX_OCUPACIONES
      errors.add(:invitaciones,
                 "No puede haber más de #{MAX_OCUPACIONES} lugares ocupados.")
    end
  end

  def cumple_dia
    dias_permitidos = if user.grupo
                        user.grupo.dias_permitidos
                      else
                        DIAS_PERMITIDOS
                      end
    unless dias_permitidos[start_time.wday] == 1
      errors.add(:dias_permitidos,
                 "Dicho día no está permitido reservar")
    end
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def cumple_horario_apertura
    if user.grupo
      horas_apertura_grupo = user.grupo.start_times
      horas_cierre_grupo = user.grupo.end_times
    else
      horas_apertura_grupo = HORAS_APERTURA
      horas_cierre_grupo = HORAS_CIERRE
    end
    horario_apertura = [
      start_time.change(hour: horas_apertura_grupo[start_time.wday]),
      end_time.change(hour: horas_cierre_grupo[start_time.wday])
    ]
    unless contenido_en(*horario_apertura)
      errors.add(:horario_de_apertura,
                 "El horario debe estar entre
                 #{horas_apertura_grupo[start_time.wday]} hs y #{horas_cierre_grupo[start_time.wday]} hs")
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def check_bloqueos
    unless user.admin?
      bloqueos = Reserva.del_dia(self).where(bloqueo: true)
      bloqueos.each do |bloqueo|
        next unless bloqueo != self

        next unless solapa_con?(bloqueo.start_time, bloqueo.end_time)

        errors.add(
          :bloqueado,
          "El horario de #{bloqueo.start_time} a
          #{bloqueo.end_time} está reservado por un administrador."
        )
      end
    end
  end
  # rubocop:enable Style/GuardClause

  def termina_dsp_d_q_empiece
    return if start_time < end_time

    errors.add(:hora_de_finalizacion,
               "Debe ser posterior a la hora de comienzo")
  end

  def empieza_termina_mismo_dia
    s = start_time
    e = end_time
    return if
      s.day == e.day && \
      s.month == e.month && \
      s.year == e.year \

    errors.add(:dia_de_finalizacion, "Debe finalizar el mismo día en que comienza")
  end
end
# rubocop:enable Metrics/ClassLength
