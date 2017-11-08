FactoryGirl.define do
  factory :reserva do
    start_time { DateTime.tomorrow + 7*24*rand().hour }
    end_time { start_time + 1.hour }
    user
  end
end
