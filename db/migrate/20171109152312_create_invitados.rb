class CreateInvitados < ActiveRecord::Migration[5.1]
  def change
    create_table :invitados do |t|
      t.string :nombre
      t.string :apellido
      t.bigint :dni
      t.string :email
      t.belongs_to :reserva, foreign_key: true

      t.timestamps
    end
  end
end
