class AddIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :id_tipo, :smallint
    add_column :users, :id_num, :bigint
  end
end
