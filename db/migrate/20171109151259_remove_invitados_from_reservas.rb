# frozen_string_literal: true

class RemoveInvitadosFromReservas < ActiveRecord::Migration[5.1]
  def change
    remove_column :reservas, :invitados, :json
  end
end
