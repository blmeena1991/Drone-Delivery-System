class DroneListener
  class << self
    attr_reader :drone

    def set_drone_slug(drone_id)
      drone = Drone.find(drone_id)
      drone.slug = "#{drone.name.parameterize.gsub('-', '_')}_#{drone.id}"
      drone.save
    end
  end
end
