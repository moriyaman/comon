class CreateEventParticipants < ActiveRecord::Migration
  def change
    create_table :event_participants do |t|
      t.integer :user_id
      t.integer :event_id
      t.boolean :lt_flg, :default => false
      t.boolean :cancel_flg, :default => false
      t.timestamps
    end
  end
end
