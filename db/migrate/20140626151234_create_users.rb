class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :facebook
      t.string :twitter
      t.string :github
      t.string :connpass_url
      t.timestamps
    end
    add_index :users, :connpass_url
  end
end
