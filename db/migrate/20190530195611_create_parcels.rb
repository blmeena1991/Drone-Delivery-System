class CreateParcels < ActiveRecord::Migration[5.2]
  def change
    create_table :parcels do |t|
      t.string "recipient_name"
      t.decimal  "weight",precision: 12, scale: 4, default: 0.0,   null: false
      t.integer  "destination_location_id"
      t.timestamps
    end
  end
end
