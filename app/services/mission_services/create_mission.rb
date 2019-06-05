class MissionServices::CreateMission < BaseService
  attr_reader :result

=begin
request_context =  {
  parcel_details: {
    recipient_name: "BL",
    weight: 12,
    destination_location:{
      latitude: 12,
      longitude: 13
     }
  },
  drone_id: 1,
  warehouse_id: 2
}
=end
  def initialize(context)
    super()
    @context = Hashie::Mash.new(context)
    drone_id = @context.drone_id
    @parcel_details = @context.parcel_details || {}
    @recipient_location = @parcel_details.delete(:destination_location)
    warehouse_id = @context.warehouse_id
    @drone = Drone.find_by_id(drone_id)
    @warehouse = Warehouse.find_by_id(warehouse_id)
  end

  # This should return true or false
  def execute
    return false unless super
    ActiveRecord::Base.transaction do
      # Location Create
      location_params = @recipient_location.merge({name: @parcel_details[:recipient_name] })
      recipient_loc = create_parcel_destination_location(location_params)

      # Parcel Create
      parcel_params = @parcel_details.merge({destination_location_id: recipient_loc.id })
      parcel_object = create_parcel(parcel_params) if valid?
      if valid?
        # Mission Create
        mission_params = {
            drone_id: @drone.id,
            warehouse_id: @warehouse.id,
            parcel_id: parcel_object.id
        }
        @result = create_mission(mission_params)
      end
      raise ActiveRecord::Rollback unless valid?
    end
    valid?
  end

  protected

  def validate
    super
    error "Drone, Warehouse and Parcel details required to create the mission" if @drone.blank? || @parcel_details.blank? || @warehouse.blank?
    return unless valid?
    error "Destination location required to create the mission" if  @recipient_location.blank?
    return unless valid?
    error "Drone already on some mission" unless @drone.parking?
  end

  private

  def create_parcel(parcel_params)
    parcel = Parcel.create(Hash[parcel_params])
    if parcel.errors.present?
      error parcel.errors.full_messages
    end

    parcel
  end

  def create_parcel_destination_location(location_params)
    destination_location = Location.create(Hash[location_params])
    if destination_location.errors.present?
      error destination_location.errors.full_messages
    end

    destination_location
  end

  def create_mission(mission_params)
    mission = Mission.create(mission_params)
    if mission.errors.present?
      error mission.errors.full_messages
    end
    mission
  end
end