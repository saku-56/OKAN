class CreateHospitals < ActiveRecord::Migration[7.2]
  def change
    create_table :hospitals do |t|
      t.string :name, null: false
      t.text :description
      t.uuid :uuid, default: 'gen_random_uuid()', null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :hospitals, :uuid, unique: true
  end
end
