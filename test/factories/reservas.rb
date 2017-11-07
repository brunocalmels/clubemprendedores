FactoryGirl.define do
  factory :reserva do
    start_time { DateTime.now + 7*24*rand().hour }
    end_time { start_time + 1 + rand(3) }
    user
  end
end
