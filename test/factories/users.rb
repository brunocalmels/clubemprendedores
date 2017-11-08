FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(6) }
    nombre { Faker::Name.first_name }
    apellido { Faker::Name.last_name }
    telefono { Faker::Number.number(7) }
    id_tipo { rand(0..2) }
    id_num { rand(20000000..50000000) }
    institucion { Faker::University.name }
    admin { false }

    factory :admin do
      admin { true }
    end

  end
end
