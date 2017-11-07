FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(6) }
    nombre { Faker::Name.first_name }
    apellido { Faker::Name.last_name }
    telefono { Faker::Number.number(7) }
    id_tipo { [0..2].sample }
    id_num { [200000000..50000000] }
    institucion { Faker::University.name }
  end
end
