FactoryBot.define do
  factory :reserva do

    # Entre hoy y dentro de una semana, entre las 8:00 y las 21:00
    start_time { (DateTime.now.middle_of_day) + rand(0..7)*24.hour + rand(-3..4).hour }
    end_time { start_time + 1.hour }
    finalidad { FINALIDADES.sample }

    user

    factory :reserva_bloqueante do
      user { admins.sample }
      bloqueo true
    end

  end
end
