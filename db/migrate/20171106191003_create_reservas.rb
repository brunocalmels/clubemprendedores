# frozen_string_literal: true

class CreateReservas < ActiveRecord::Migration[5.1]
  def change
    create_table :reservas do |t|
      t.datetime :end_time
      t.datetime :start_time

      t.timestamps
    end
  end
end
