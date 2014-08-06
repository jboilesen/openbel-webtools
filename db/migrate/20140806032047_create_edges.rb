class CreateEdges < ActiveRecord::Migration
  def change
    create_table :edges do |t|
      t.string :label
      t.belongs_to :source
      t.belongs_to :target
      t.belongs_to :graph
      t.timestamps
    end
    add_index :edges, :source_id
    add_index :edges, :target_id
    add_index :edges, :graph_id
    reversible do |dir|
      dir.up do
        #add a foreign key
        execute <<-SQL
          ALTER TABLE edges
            ADD CONSTRAINT fk_edge_source_node
            FOREIGN KEY (source_id)
            REFERENCES nodes(id)
        SQL
        execute <<-SQL
          ALTER TABLE edges   
            ADD CONSTRAINT fk_edge_target_node
            FOREIGN KEY (target_id)
            REFERENCES nodes(id)
        SQL
        execute <<-SQL
          ALTER TABLE edges
            ADD CONSTRAINT fk_edge_graph
            FOREIGN KEY (graph_id)
            REFERENCES graphs(id)
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE edges
            DROP FOREIGN KEY fk_edge_source_node
        SQL
        execute <<-SQL
          ALTER TABLE edges
            DROP FOREIGN KEY fk_edge_target_node      
        SQL
        execute <<-SQL
          ALTER TABLE edges
            DROP FOREIGN KEY fk_edge_graph
        SQL
      end
    end
  end
end
