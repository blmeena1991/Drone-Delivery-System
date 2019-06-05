class AddDestinationLocationToDrone < ActiveRecord::Migration[5.2]
  def change
    add_column :drones, :destination_location_id, :integer
  end
end
