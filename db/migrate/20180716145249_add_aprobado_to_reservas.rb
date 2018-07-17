class AddAprobadoToReservas < ActiveRecord::Migration[5.1]
  def change
    add_column :reservas, :aprobado, :boolean, default: true
  end
end
