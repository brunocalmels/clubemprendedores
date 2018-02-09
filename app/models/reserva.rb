class Reserva < ApplicationRecord
  belongs_to :user, optional: false

  has_many :invitados
  accepts_nested_attributes_for :invitados, reject_if: proc { |attributes| attributes[:nombre].blank? or attributes[:apellido].blank? }, allow_destroy: true

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
      self.start_time >= hora_ini && self.start_time < hora_fin ||
      self.end_time   > hora_ini && self.end_time   <= hora_fin ||
      self.start_time <= hora_ini && self.end_time   >= hora_fin
    )
      true
    else
      false
    end
  end

  def contenido_en(hora_ini, hora_fin)
    self.start_time >= hora_ini && self.end_time <= hora_fin
  end

  private

  def cumple_horario_apertura
    horario_apertura = [self.start_time.change(hour: HORA_APERTURA), self.end_time.change(hour: HORA_CIERRE)]
    errors.add(:horario_de_apertura, "El horario debe estar entre #{HORA_APERTURA} hs y #{HORA_CIERRE} hs") unless self.contenido_en(*horario_apertura)
  end

  def check_bloqueos
    bloqueos = Reserva.where(bloqueo: true)
    bloqueos_del_dia = []
    bloqueos.each do |bloqueo|
      if(
        self.start_time > bloqueo.start_time && self.start_time < bloqueo.end_time ||
        self.end_time   > bloqueo.start_time && self.end_time   < bloqueo.end_time ||
        self.start_time < bloqueo.start_time && self.end_time   > bloqueo.end_time
        )
        errors.add(:bloqueado, "El horario de #{bloqueo.start_time} a #{bloqueo.end_time} está reservado por un administrador.")
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
