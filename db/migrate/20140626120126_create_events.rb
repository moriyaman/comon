class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :address
      t.string :url
      t.text :description
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :limit
      t.timestamps
    end
    add_index :events, :started_at
    add_index :events, :ended_at
  end
end
