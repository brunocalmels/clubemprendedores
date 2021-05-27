# frozen_string_literal: true

class AddUserToReservas < ActiveRecord::Migration[5.1]
  def change
    add_reference :reservas, :user, foreign_key: true
  end
end
