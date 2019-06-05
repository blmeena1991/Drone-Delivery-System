class MissionListener
  class << self
    attr_reader :mission

    def drone_ready_for_mission(mission_id)
      mission = Mission.find(mission_id)
      drone = mission.drone
      drone.on_mission!
      drone.current_location_id = drone.parking_location_id
      drone.destination_location_id = mission.warehouse.origin_location_id
      drone.save!
      DroneLog.info "Drone #{mission.drone.name} is ready for mission.Going to watehouse #{mission.warehouse.name} for pick the parcel item #{mission.parcel.id}"
      PublishToMqtt.mission_start_by_drone(mission_id)
    end

    def item_pick_up(mission_id)
      mission = Mission.find(mission_id)
      drone = mission.drone
      drone.current_location_id = mission.warehouse.origin_location_id
      drone.destination_location_id = mission.parcel.destination_location_id
      drone.save!
      mission.leave_for_delivery
    end

    def drone_reach_to_destination(mission_id)
      mission = Mission.find(mission_id)
      drone = mission.drone
      drone.current_location_id = mission.parcel.destination_location_id
      drone.save!
      DroneLog.info "Drone #{drone.name} has reach to destination #{mission.parcel.destination_location.latitude},#{mission.parcel.destination_location.longitude} with parcel id:#{mission.parcel_id} and sent the intrustion to CommandCenter"
    end

    def signal_for_unload_item(mission_id)
      mission = Mission.find(mission_id)
      drone = mission.drone
      drone.current_location_id = mission.parcel.destination_location_id
      drone.destination_location_id = drone.parking_location_id
      drone.save!
      DroneLog.info "Drone #{drone.name} unload  parcel item id:#{mission.parcel_id} and sent the intrustion to CommandCenter"
    end

    def reach_to_parking_spot(mission_id)
      mission = Mission.find(mission_id)
      mission.end_time = DateTime.now
      mission.save!
      drone = mission.drone
      drone.status = "parking"
      drone.current_location_id = drone.parking_location_id
      drone.destination_location_id = drone.parking_location_id
      drone.save!
      DroneLog.info "Drone #{drone.name} reached to parking spot and ready for next mission and sent the intrustion to CommandCenter"
    end

    def reply_from_drone(message)
      DroneLog.info "#{message}"
      options = JSON.parse(message).with_indifferent_access
      DroneLog.info "Drone status: #{options["status"]}"
      mission_id = options["mission_id"].to_i
      mission = Mission.find_by_id(mission_id)
      return if mission.blank?
      drone = mission.drone
      case options["status"]
      when "item_pick_up"
        mission.item_pickup!
      when "reached_destination"
        mission.reached_to_destination!
      when "unload_item"
        mission.item_delivered!
      when "ready_for_next_mission"
        mission.completed!
      else
        raise ValidationError, "Drone send wrong instruction"
      end
    end
  end
end
