# == Schema Information
#
# Table name: reservas
#
#  id          :bigint(8)        not null, primary key
#  aprobado    :boolean          default(TRUE)
#  bloqueo     :boolean          default(FALSE)
#  descripcion :string
#  end_time    :datetime
#  finalidad   :string
#  nombre      :string
#  start_time  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint(8)
#
# Indexes
#
#  index_reservas_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :reserva do
    # Entre hoy y dentro de una semana, entre las 8:00 y las 21:00
    start_time { DateTime.now.middle_of_day + rand(0..7) * 24.hours + rand(-3..4).hour }
    end_time { start_time + 1.hour }
    finalidad { FINALIDADES.sample }

    user

    factory :reserva_bloqueante do
      user { admins.sample }
      bloqueo true
    end
  end
end
