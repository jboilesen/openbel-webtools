class CreateBelfiles < ActiveRecord::Migration
  def change
    create_table :belfiles do |t|
      t.string :title
      t.text :description
      t.string :belfile_path
      t.timestamps
    end
  end
end
