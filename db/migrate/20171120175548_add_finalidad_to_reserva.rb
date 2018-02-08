class AddFinalidadToReserva < ActiveRecord::Migration[5.1]
  def change
    add_column :reservas, :finalidad, :string
  end
end
