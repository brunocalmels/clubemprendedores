class Invitado < ApplicationRecord
  belongs_to :reserva, inverse_of: :invitados

  scope :no_anonimos, -> { where(anonimo: false) }

  validates :nombre, :apellido, presence: true, unless: Proc.new { |invit| invit.anonimo?  }

end
