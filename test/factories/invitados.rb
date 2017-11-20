FactoryGirl.define do
  factory :invitado do
    nombre   { Faker::Name.first_name }
    apellido { Faker::Name.last_name }
    dni { rand(20000000..50000000) }
    email { Faker::Internet.email }
    anonimo { false }
    reserva
  end
end
