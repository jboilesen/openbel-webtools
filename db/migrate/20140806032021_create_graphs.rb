class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.string :label
      t.boolean :directed
      t.belongs_to :belfile
      t.timestamps
    end
    add_index :graphs, :belfile_id
    reversible do |dir|
      dir.up do
        #add a foreign key
        execute <<-SQL
          ALTER TABLE graphs
            ADD CONSTRAINT fk_graph_belfile
            FOREIGN KEY (belfile_id)
            REFERENCES belfiles(id)
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE graphs
            DROP FOREIGN KEY fk_graph_belfile
        SQL
      end
    end
  end
end
