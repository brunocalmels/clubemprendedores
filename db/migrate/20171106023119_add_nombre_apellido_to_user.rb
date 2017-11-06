class AddNombreApellidoToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :nombre, :string
    add_column :users, :apellido, :string
  end
end
