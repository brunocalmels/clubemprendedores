json.extract! reserva, :id, :end_time, :start_time, :created_at, :updated_at
json.url reserva_url(reserva, format: :json)
