# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'factory_girl_rails'

p 'Creando admin Maxi'
maxi = User.create(admin: true, email: 'mgrande@cpymeadeneu.com.ar', password: 'maxclubemp', nombre: 'Maxi', apellido: 'Grande', id_tipo: 0, id_num: 123456789, institucion: 'Club Emprendedor')
p 'Creando turnos bloqueantes'
3.times do
  reserva = FactoryGirl.build(:reserva, user: maxi, bloqueo: true)
  p reserva
  reserva.save
end

p 'Creando usuario Bruno'
User.create!(email: 'brunocalmels@gmail.com', password:'bruclubemp', nombre: 'Bruno', apellido: 'Calmels', id_tipo: 0, id_num: 32974644, institucion: 'Macher IT')

p 'Creando 10 usuarios'
p '...con una reserva cada uno'
10.times do
  user = FactoryGirl.create(:user)
  reserva = FactoryGirl.build(:reserva, user: user)
  p reserva
  reserva.save
end
