# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  admin                  :boolean          default(FALSE)
#  apellido               :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  id_num                 :bigint(8)
#  id_tipo                :integer
#  institucion            :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  nombre                 :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  telefono               :bigint(8)
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  grupo_id               :bigint(8)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_grupo_id              (grupo_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (grupo_id => grupos.id)
#

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(6) }
    nombre { Faker::Name.first_name }
    apellido { Faker::Name.last_name }
    telefono { Faker::Number.number(7) }
    id_tipo { rand(0..2) }
    id_num { rand(20_000_000..50_000_000) }
    institucion { Faker::University.name }
    admin { false }

    factory :admin do
      admin { true }
    end
  end
end
