# frozen_string_literal: true

class AddInstitucionToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :institucion, :string
  end
end
