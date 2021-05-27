# frozen_string_literal: true

# == Schema Information
#
# Table name: invitados
#
#  id         :bigint(8)        not null, primary key
#  anonimo    :boolean          default(FALSE)
#  apellido   :string
#  dni        :bigint(8)
#  email      :string
#  nombre     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  reserva_id :bigint(8)
#
# Indexes
#
#  index_invitados_on_reserva_id  (reserva_id)
#
# Foreign Keys
#
#  fk_rails_...  (reserva_id => reservas.id)
#

class Invitado < ApplicationRecord
  belongs_to :reserva, inverse_of: :invitados

  scope :no_anonimos, -> { where(anonimo: false) }

  validates :nombre, :apellido, presence: true, unless: proc { |invit| invit.anonimo? }
end
