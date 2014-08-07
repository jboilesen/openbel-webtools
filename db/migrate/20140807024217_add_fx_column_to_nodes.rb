class AddFxColumnToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :fx, :string, :after => :label
  end
end
