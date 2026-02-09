class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :notification_type, null: false
      t.boolean :enabled, default: false, null: false
      t.integer :days_before, null: false, default: 1

      t.timestamps
    end

    add_index :notifications, [ :user_id, :notification_type ], unique: true
  end
end
