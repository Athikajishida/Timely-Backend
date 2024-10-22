class CreateEventParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :event_participants do |t|
      t.references :event, null: false, foreign_key: true
      t.string :email, null: false

      t.timestamps
    end
    
    add_index :event_participants, [:event_id, :email], unique: true
  end
end
