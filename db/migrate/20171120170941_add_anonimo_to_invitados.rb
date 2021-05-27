# frozen_string_literal: true

class AddAnonimoToInvitados < ActiveRecord::Migration[5.1]
  def change
    add_column :invitados, :anonimo, :boolean, default: false
  end
end
