class Invitado < ApplicationRecord
  belongs_to :reserva, inverse_of: :invitados
end
