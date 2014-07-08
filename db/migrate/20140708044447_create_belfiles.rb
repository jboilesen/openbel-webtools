class CreateBelfiles < ActiveRecord::Migration
  def change
    create_table :belfiles do |t|
      t.string :title
      t.text :description
      t.binary :belfile
      t.string :url

      t.timestamps
    end
  end
end
