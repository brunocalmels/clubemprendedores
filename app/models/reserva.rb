class Reserva < ApplicationRecord
  belongs_to :user, optional: false

  validates :start_time, presence: true
  validates :end_time, presence: true

  # Que termine después de que empiece
  validate :end_post_start
  # Que termine el mismo día que empieza
  validate :end_start_mismo_dia
  # Que los invitados tengan nombre y apellido
  validate :atributos_invitados

  def invitados
    read_attribute(:invitados).map { |v| Invitado.new(v) }
  end

  def invitados_attributes=(attributes)
    invitados = []
    attributes.each do |_index, attrs|
      next if attrs.delete('_destroy') == '1'
      invitados << attrs
    end
    write_attribute(:invitados, invitados)
  end

  def build_invitado
    inv = invitados.dup
    inv << Invitado.new(nombre: '', apellido: '', dni: '', email: '')
    self.invitados = inv
  end

  class Invitado
    attr_accessor :nombre, :apellido, :dni, :email

    def persisted?
      false
    end

    def new_record?
      false
    end

    def marked_for_destruction?
      false
    end

    def _destroy
      false
    end

    def initialize(hash)
      @nombre = hash['nombre']
      @apellido = hash['apellido']
      @dni = hash['dni']
      @email = hash['email']
    end
  end

  private

  def end_post_start
    errors.add(:hora_de_finalizacion, 'Debe ser posterior a la hora de comienzo') unless start_time < end_time
  end

  def end_start_mismo_dia
    s = start_time
    e = end_time
    errors.add(:dia_de_finalizacion, 'Debe finalizar el mismo día en que comienza') unless s.day == e.day && s.month == e.month && s.year == e.year
  end

  def atributos_invitados
    if invitados.any?
      invitados.each do |invitado|
        unless invitado.nombre && invitado.apellido
          errors.add(:invitados, 'Se debe informar los nombres y apellidos')
        end
      end
    end
  end
end
