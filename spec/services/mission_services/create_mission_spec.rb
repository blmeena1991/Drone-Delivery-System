require 'rails_helper'
describe MissionServices::CreateMission  do
  let!(:drone_location) { create :location}
  let!(:warehouse_location) { create :location}
  let!(:drone) { create :drone, current_location: drone_location, destination_location: drone_location, parking_location: drone_location}
  let!(:warehouse) { create :warehouse, origin_location: warehouse_location}

  let!(:mission_params) do
    {
        parcel_details:
          {
              recipient_name: "BL",
              weight: 12,
              destination_location:
                  {
                      latitude: 12,
                      longitude: 13
                  }
          },
        drone_id: drone.id,
        warehouse_id: warehouse.id
    }
  end

  describe "Create Mission Service" do
    it 'when request attributes are valid' do
      mission_service = MissionServices::CreateMission.new(mission_params)
      mission_service.execute
      expect(mission_service.errors).to be_blank
      expect(mission_service.result).to be_present
    end
  end

  describe "Create Mission Service" do
    it 'when request attributes are in_valid' do
      drone.on_mission!
      mission_service = MissionServices::CreateMission.new(mission_params)
      mission_service.execute
      expect(mission_service.errors).to be_present
    end
  end

  describe "Complted Mission flow" do
    context 'when the record exists' do
      let!(:parcel_location) { create :location}
      let!(:parcel) { create :parcel, destination_location: parcel_location}
      let!(:mission) { create :mission, drone: drone,parcel: parcel, warehouse: warehouse}

# SETP 1 : When Drone pick up the item from warehouse
      it 'Start Mission' do
        ::Publisher.broadcast :reply_from_drone, {"mission_id": mission.id,"status": "item_pick_up"}.to_json
        mission_deaitls = Mission.find(mission.id)
        expect(mission_deaitls.status).to eq("out_for_delivery")
        ::Publisher.broadcast :reply_from_drone,  {"mission_id": mission.id,"status": "reached_destination"}.to_json
        mission_deaitls = Mission.find(mission.id)
        expect(mission_deaitls.status).to eq("reached_to_destination")
        ::Publisher.broadcast :reply_from_drone,{"mission_id": mission.id,"status": "unload_item"}.to_json
        mission_deaitls = Mission.find(mission.id)
        expect(mission_deaitls.status).to eq("item_delivered")

        ::Publisher.broadcast :reply_from_drone, {"mission_id": mission.id,"status": "ready_for_next_mission"}.to_json
        mission_deaitls = Mission.find(mission.id)
        expect(mission_deaitls.status).to eq("completed")
      end

=begin
      #SETP 2 : When Drone reached destination
      it 'reached_destination' do
        ::Publisher.broadcast :reply_from_drone,  {"mission_id": mission.id,"status": "reached_destination"}.to_json
        mission_deaitls = Mission.find(mission.id)
        expect(mission_deaitls.status).to eq("reached_to_destination")
      end

      #SETP 3 : When Drone unload item
      it 'unload_item' do
        ::Publisher.broadcast :reply_from_drone,{"mission_id": mission.id,"status": "unload_item"}.to_json
        mission_deaitls = Mission.find(mission.id)
        expect(mission_deaitls.status).to eq("item_delivered")
      end

      #SETP 4 : When Drone ready for next mission
      it 'ready_for_next_mission' do
        ::Publisher.broadcast :reply_from_drone, {"mission_id": mission.id,"status": "ready_for_next_mission"}.to_json
        mission_deaitls = Mission.find(mission.id)
        expect(mission_deaitls.status).to eq("completed")
      end
=end
    end
  end
end