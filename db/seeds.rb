# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'factory_girl_rails'

p 'Creando usuario Bruno'
User.create!(email: 'brunocalmels@gmail.com', password:'bruclubemp')

p 'Creando 10 usuarios'
p 'Con una reserva cada uno'
10.times do
  user = FactoryGirl.create(:user)
  reserva = FactoryGirl.create(:reserva, user: user)

end
