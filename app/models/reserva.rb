class Reserva < ApplicationRecord
  belongs_to :user, optional: false

  has_many :invitados
  accepts_nested_attributes_for :invitados, reject_if: proc { |attributes| attributes[:nombre].blank? or attributes[:apellido].blank? }, allow_destroy: true

  validates :start_time, presence: true
  validates :end_time, presence: true

  # Que termine después de que empiece
  validate :end_post_start
  # Que termine el mismo día que empieza
  validate :end_start_mismo_dia

  # Que no haya reservas bloqueantes ese mismo día
  validate :check_bloqueos

  def hora_comienzo
    start_time.strftime('%k:%M')
  end
  def hora_fin
    end_time.strftime('%k:%M')
  end


  private

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

  def end_post_start
    errors.add(:hora_de_finalizacion, 'Debe ser posterior a la hora de comienzo') unless start_time < end_time
  end

  def end_start_mismo_dia
    s = start_time
    e = end_time
    errors.add(:dia_de_finalizacion, 'Debe finalizar el mismo día en que comienza') unless s.day == e.day && s.month == e.month && s.year == e.year
  end

end
