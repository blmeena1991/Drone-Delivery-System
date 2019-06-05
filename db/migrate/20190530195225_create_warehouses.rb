class CreateWarehouses < ActiveRecord::Migration[5.2]
  def change
    create_table :warehouses do |t|
      t.string "name"
      t.string "slug"
      t.integer "origin_location_id"
      t.timestamps
    end
  end
end
