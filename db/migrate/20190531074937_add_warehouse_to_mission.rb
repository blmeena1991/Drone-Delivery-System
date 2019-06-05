class AddWarehouseToMission < ActiveRecord::Migration[5.2]
  def change
    add_reference :missions, :warehouse, foreign_key: true
  end
end
