class Reserva < ApplicationRecord
  belongs_to :user, optional: false
  has_many :invitados, dependent: :destroy
  accepts_nested_attributes_for :invitados, reject_if: proc { |attributes| attributes[:nombre].blank? or attributes[:apellido].blank? }, allow_destroy: true

  scope :del_dia, ->(reserva) { where('extract(day from start_time) = ?', reserva.start_time.day).where('extract(month from start_time) = ?', reserva.start_time.month).where('extract(year from start_time) = ?', reserva.start_time.year) }

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :finalidad, inclusion: { in: FINALIDADES }

  # Que termine después de que empiece
  validate :termina_dsp_d_q_empiece
  # Que termine el mismo día que empieza
  validate :empieza_termina_mismo_dia

  # Que esté dentro de la franja horaria permitida
  validate :cumple_horario_apertura

  # Que no haya reservas bloqueantes ese mismo día
  validate :check_bloqueos

  # Que no haya más del máximo permitido de ocupaciones
  validate :max_ocupaciones_propias
  validate :max_ocupaciones

  def fecha
    start_time.strftime('%-d/%-m')
  end
  def hora_comienzo
    start_time.strftime('%k:%M')
  end
  def hora_fin
    end_time.strftime('%k:%M')
  end

  def ocupaciones
    invitados.count + 1
  end


  def solapa_con?(hora_ini, hora_fin)
    if(
      start_time <  hora_fin && start_time > hora_ini ||
      start_time <= hora_ini && end_time   > hora_ini
    )
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
      if otra_reserva != self && solapa_con?(otra_reserva.start_time, otra_reserva.end_time) && ocupaciones + otra_reserva.ocupaciones > MAX_OCUPACIONES
          errors.add(:ocupaciones, "El turno excede la cantidad de lugares porque ya hay otro turno de #{otra_reserva.user.nombre_completo} con #{otra_reserva.ocupaciones} ocupaciones con el que éste se solapa.")
      end
    end
  end

  def max_ocupaciones_propias
    if ocupaciones > MAX_OCUPACIONES
      errors.add(:invitaciones, "No puede haber más de #{MAX_OCUPACIONES} lugares ocupados.")
    end
  end

  def cumple_horario_apertura
    horario_apertura = [start_time.change(hour: HORA_APERTURA), end_time.change(hour: HORA_CIERRE)]
    errors.add(:horario_de_apertura, "El horario debe estar entre #{HORA_APERTURA} hs y #{HORA_CIERRE} hs") unless contenido_en(*horario_apertura)
  end

  def check_bloqueos
    if !user.admin?
      bloqueos = Reserva.del_dia(self).where(bloqueo: true)
      bloqueos.each do |bloqueo|
        if bloqueo != self && solapa_con?(bloqueo.start_time, bloqueo.end_time)
          errors.add(:bloqueado, "El horario de #{bloqueo.start_time} a #{bloqueo.end_time} está reservado por un administrador.")
        end
      end
    end
  end

  def termina_dsp_d_q_empiece
    errors.add(:hora_de_finalizacion, 'Debe ser posterior a la hora de comienzo') unless start_time < end_time
  end

  def empieza_termina_mismo_dia
    s = start_time
    e = end_time
    errors.add(:dia_de_finalizacion, 'Debe finalizar el mismo día en que comienza') unless s.day == e.day && s.month == e.month && s.year == e.year
  end

end
