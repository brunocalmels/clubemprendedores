namespace :mantenimiento do
  desc "Limpia reservas de hace más de un mes"
  task :limpia_reservas_viejas => :environment do
    puts "Mantenimiento: limpiando reservas de hace más de un mes"
    Reserva.where('start_time < ?', Time.now - 1.month).destroy_all
    puts "Listo"
  end
end
