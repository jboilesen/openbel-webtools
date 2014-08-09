class RenameEdgeLabelToRelation < ActiveRecord::Migration
  def change
    rename_column :edges, :label, :relation
  end
end
