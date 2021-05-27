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

FactoryBot.define do
  factory :invitado do
    nombre { Faker::Name.first_name }
    apellido { Faker::Name.last_name }
    dni { rand(20_000_000..50_000_000) }
    email { Faker::Internet.email }
    anonimo { false }
    reserva
  end
end
