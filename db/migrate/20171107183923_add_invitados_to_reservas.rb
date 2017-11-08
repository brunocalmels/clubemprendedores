class AddInvitadosToReservas < ActiveRecord::Migration[5.1]
  def change
    add_column :reservas, :invitados, :json, default: []
  end
end
