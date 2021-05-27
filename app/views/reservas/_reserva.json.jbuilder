# frozen_string_literal: true

json.extract! reserva, :id, :end_time, :start_time, :bloqueo, :finalidad, :created_at, :updated_at
json.url reserva_url(reserva, format: :json)
