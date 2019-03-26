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
            if: proc { |reserva| reserva.finalidad == "Eventos/capacitaciones" }
  validates :nombre,
            length: { minimum: RESERVA_NOMBRE_MIN, maximum: RESERVA_NOMBRE_MAX },
            if: proc { |reserva| reserva.finalidad == "Eventos/capacitaciones" }
  validates :descripcion,
            length: { minimum: RESERVA_DESCRIPCION_MIN, maximum: RESERVA_DESCRIPCION_MAX },
            if: proc { |reserva| reserva.finalidad == "Eventos/capacitaciones" }

  # Que termine después de que empiece
  validate :termina_dsp_d_q_empiece
  # Que termine el mismo día que empieza
  validate :empieza_termina_mismo_dia

  # Que esté dentro de la franja horaria permitida
  validate :cumple_horario_apertura

  # Que no haya reservas bloqueantes en ese mismo periodo
  validate :check_bloqueos

  # Que no haya más del máximo permitido de ocupaciones
  validate :max_ocupaciones_propias
  validate :max_ocupaciones

  def fecha
    start_time.strftime("%-d/%-m")
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

  # rubocop:disable AbcSize
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
  # rubocop:enable AbcSize

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

  # rubocop:disable AbcSize
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
  # rubocop:enable AbcSize

  # rubocop:disable Style/GuardClause
  def max_ocupaciones_propias
    if ocupaciones > MAX_OCUPACIONES
      errors.add(:invitaciones,
                 "No puede haber más de #{MAX_OCUPACIONES} lugares ocupados.")
    end
  end

  # rubocop:disable Metrics/AbcSize
  def cumple_horario_apertura
    horario_apertura = [
      start_time.change(hour: HORAS_APERTURA[start_time.wday]),
      end_time.change(hour: HORAS_CIERRE[start_time.wday])
    ]
    unless contenido_en(*horario_apertura)
      errors.add(:horario_de_apertura,
                 "El horario debe estar entre
                 #{HORAS_APERTURA[start_time.wday]} hs y #{HORAS_CIERRE[start_time.wday]} hs")
    end
  end
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
