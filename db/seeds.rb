# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'factory_bot_rails'

p 'Creando admin Maxi'
maxi = User.create(admin: true, email: 'mgrande@adeneu.com.ar', password: 'maxclubemp', nombre: 'Maxi', apellido: 'Grande', id_tipo: 0, id_num: 123456789, institucion: 'Club Emprendedor')
p 'Creando turnos bloqueantes'
3.times do
  reserva = FactoryBot.build(:reserva, user: maxi, bloqueo: true)
  # p reserva
  reserva.save
  if reserva.persisted?
    p '... con invitados anónimos'
    rand(1..20).times do |t|
      FactoryBot.create(:invitado, reserva: reserva, anonimo: true)
    end
  end
end

p 'Creando usuarios Lu, Gabo, Rober'
User.create(admin: true, email: 'lmarquisio@adeneu.com.ar', password: '123456', nombre: 'Lucila', apellido: 'Marquisio', id_tipo: 0, id_num: 123456789, institucion: 'Club Emprendedor')
User.create(admin: true, email: 'gcarnelli@adeneu.com.ar', password: '123456', nombre: 'Gabriel', apellido: 'Carnelli', id_tipo: 0, id_num: 123456789, institucion: 'Club Emprendedor')
User.create(admin: true, email: 'rcamino@adeneu.com.ar', password: '123456', nombre: 'Roberto', apellido: 'Camino', id_tipo: 0, id_num: 123456789, institucion: 'Club Emprendedor')

p 'Creando usuario Bruno'
User.create!(email: 'brunocalmels@gmail.com', password:'bruclubemp', nombre: 'Bruno', apellido: 'Calmels', id_tipo: 0, id_num: 32974644, institucion: 'Macher IT')

p 'Creando 10 usuarios'
p '...con una reserva cada uno'
10.times do
  user = FactoryBot.create(:user)
  reserva = FactoryBot.build(:reserva, user: user)
  reserva.save
  if reserva.persisted?
    rand(0..5).times do
      FactoryBot.create(:invitado, reserva: reserva)
    end
  end
end
