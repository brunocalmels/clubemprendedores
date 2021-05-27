# frozen_string_literal: true

json.extract! grupo, :id, :nombre, :start_time, :end_time, :created_at, :updated_at
json.url grupo_url(grupo, format: :json)
