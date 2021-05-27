# frozen_string_literal: true

class AddDiasPermitidosToGrupo < ActiveRecord::Migration[5.1]
  def change
    add_column :grupos, :dias_permitidos, :integer, array: true, default: []
  end
end
