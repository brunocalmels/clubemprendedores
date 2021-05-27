# frozen_string_literal: true

class AddBloqueoToReserva < ActiveRecord::Migration[5.1]
  def change
    add_column :reservas, :bloqueo, :boolean, default: false
  end
end
