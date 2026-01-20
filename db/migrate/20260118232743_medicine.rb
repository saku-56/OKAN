class Medicine < ActiveRecord::Migration[7.2]
  def change
    create_table :medicines do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
    add_index :medicines, [ :user_id, :name ], unique: true
  end
end
