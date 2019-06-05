class CreateMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :missions do |t|
      t.references :drone, foreign_key: true
      t.references :parcel, foreign_key: true
      t.integer  "status", default: 0
      t.datetime "start_time"
      t.datetime "end_time"
      t.timestamps
    end
  end
end
