=begin
parcel_details = {
    parcel_details:
        {
            recipient_name: "BL",
            weight: 12,
            destination_location:
                {
                    latitude: 12, longitude: 13
                }
        },
    drone_id: 1,
    warehouse_id: 1}
=end
module CommandCenter
  class << self
    def instruct_to_pick_up(drone_id, warehouse_id,parcel_details = {})
      request_context = {
          parcel_details:parcel_details,
          drone_id: drone_id,
          warehouse_id: warehouse_id
      }
      mission = MissionServices::CreateMission.new(request_context)
      mission.execute!
    end
  end
end

