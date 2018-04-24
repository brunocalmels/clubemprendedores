class Invitado < ApplicationRecord
  belongs_to :reserva, inverse_of: :invitados

  validates :nombre, :apellido, presence: true
end
