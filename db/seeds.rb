# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "factory_bot_rails"

logger = Logger.new(STDOUT)

logger.info "Creando grupo Adeneu"
adeneu = Grupo.create(nombre: "Adeneu", start_times: HORAS_APERTURA_ADENEU, end_times: HORAS_CIERRE_ADENEU, dias_permitidos: DIAS_PERMITIDOS_ADENEU)

logger.info "Creando admin Maxi"
maxi = User.create(admin: true, email: "mgrande@adeneu.com.ar", password: "maxclubemp", nombre: "Maxi", apellido: "Grande", id_tipo: 0, id_num: 123_456_789, institucion: "Club Emprendedor")
maxi.confirm
logger.info "Creando turnos bloqueantes"
3.times do
  reserva = FactoryBot.build(:reserva, user: maxi, bloqueo: true)
  # logger.info reserva
  reserva.save
  next unless reserva.persisted?

  logger.info "... con invitados anónimos"
  rand(1..20).times do |_t|
    FactoryBot.create(:invitado, reserva: reserva, anonimo: true)
  end
end

logger.info "Creando usuarios Lu, Gabo, Rober"
User.create(admin: true, grupo: adeneu, email: "lmarquisio@adeneu.com.ar", password: "123456", nombre: "Lucila", apellido: "Marquisio", id_tipo: 0, id_num: 123_456_789, institucion: "Club Emprendedor")
User.create(admin: true, grupo: adeneu, email: "gcarnelli@adeneu.com.ar", password: "123456", nombre: "Gabriel", apellido: "Carnelli", id_tipo: 0, id_num: 123_456_789, institucion: "Club Emprendedor")
User.create(admin: true, grupo: adeneu, email: "rcamino@adeneu.com.ar", password: "123456", nombre: "Roberto", apellido: "Camino", id_tipo: 0, id_num: 123_456_789, institucion: "Club Emprendedor")

logger.info "Creando usuario Bruno"
User.create!(email: "brunocalmels@gmail.com", grupo: adeneu, password: "bruclubemp", nombre: "Bruno", apellido: "Calmels", id_tipo: 0, id_num: 32_974_644, institucion: "Macher IT", confirmed: true)

logger.info "Creando 10 usuarios"
logger.info "...con una reserva cada uno"
10.times do
  user = FactoryBot.create(:user)
  reserva = FactoryBot.build(:reserva, user: user)
  reserva.save
  next unless reserva.persisted?

  rand(0..5).times do
    FactoryBot.create(:invitado, reserva: reserva)
  end
end

logger.info "Creando eventos"
10.times do
  reserva = FactoryBot.build(:reserva, user: maxi, finalidad: "Evento/capacitación/reunión", nombre: "Capacitación App", descripcion: "Vamos a capacitar a los usuarios en el uso de la app")
  reserva.save
  next unless reserva.persisted?

  rand(0..5).times do
    FactoryBot.create(:invitado, reserva: reserva)
  end
end
