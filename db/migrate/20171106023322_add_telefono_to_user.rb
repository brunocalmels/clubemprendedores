# frozen_string_literal: true

class AddTelefonoToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :telefono, :bigint
  end
end
