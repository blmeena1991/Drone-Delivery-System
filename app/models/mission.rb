class Mission < ApplicationRecord
  #Associations
  belongs_to :drone
  belongs_to :parcel
  belongs_to :warehouse


  #Enums
  enum status: [:start, :item_pickup, :out_for_delivery,:reached_to_destination,:item_delivered, :cancelled, :completed]

  #Validations
  validates_presence_of :drone,:parcel

  #Callback
  after_initialize :set_start_time, unless: :persisted?
  after_commit :mission_start, on: :create
  after_commit :item_pick_up_by_drone, if: Proc.new{ |mission| mission.saved_change_to_status? && mission.item_pickup?}
  after_commit :reach_to_destination, if: Proc.new{ |mission| mission.saved_change_to_status? && mission.reached_to_destination?}
  after_commit :unload_item, if: Proc.new{ |mission| mission.saved_change_to_status? && mission.item_delivered?}
  after_commit :drone_reach_to_parking_spot, if: Proc.new{ |mission| mission.saved_change_to_status? && mission.completed?}


  def leave_for_delivery
    self.out_for_delivery!
    DroneLog.info "Drone #{self.drone.name} has picked parcel id:#{self.parcel_id} and leave for delivery to destination location #{self.parcel.destination_location.name}"
  end
  private

  def set_start_time
    if self.start_time.blank?
      self.start_time = DateTime.now
    end
  end

  def mission_start
    Publisher.broadcast :drone_ready_for_mission, self.id
  end

  def item_pick_up_by_drone
    Publisher.broadcast :item_pick_up, self.id
  end

  def reach_to_destination
    Publisher.broadcast :drone_reach_to_destination, self.id
  end

  def unload_item
    Publisher.broadcast :signal_for_unload_item, self.id
  end

  def drone_reach_to_parking_spot
    Publisher.broadcast :reach_to_parking_spot, self.id
  end
end
