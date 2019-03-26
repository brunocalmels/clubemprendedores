class CreateGrupos < ActiveRecord::Migration[5.1]
  def change
    create_table :grupos do |t|
      t.string :nombre, null: false
      t.integer :start_times, array: true, default: []
      t.integer :end_times, array: true, default: []

      t.timestamps
    end
  end
end
