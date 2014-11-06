class AddColumnDoorkeeperUrlToUsersForDoorkeeper < ActiveRecord::Migration
  def change
    add_column :users, :linkedin, :string
    add_index :users, :linkedin
  end
end
