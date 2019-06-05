class CreateDrones < ActiveRecord::Migration[5.2]
  def change
    create_table :drones do |t|
      t.string "name"
      t.integer  "status", default: 0
      t.string "slug"
      t.string "description"
      t.integer  "current_location_id"
      t.integer  "parking_location_id"
      t.float "battery_voltage"
      t.integer "battery_level"
      t.float "battery_current"
      t.boolean "system_status",default: true
      t.timestamps
    end
  end
end
