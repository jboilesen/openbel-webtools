class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :label
      t.belongs_to :graph
      t.timestamps
    end
    add_index :nodes, :label
    add_index :nodes, :graph_id
    
    reversible do |dir|
      dir.up do
        #add a foreign key
        execute <<-SQL
          ALTER TABLE nodes
            ADD CONSTRAINT fk_node_graph
            FOREIGN KEY (graph_id)
            REFERENCES graphs(id)
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE node
            DROP FOREIGN KEY fk_node_graph
        SQL
      end
    end
  end
end
