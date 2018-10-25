class AddNombreDescripcionToReservas < ActiveRecord::Migration[5.1]
  def change
    add_column :reservas, :nombre, :string
    add_column :reservas, :descripcion, :string
  end
end
