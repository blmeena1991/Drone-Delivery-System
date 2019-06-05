class Drone < ApplicationRecord
  #Associations
  has_many :missions, dependent: :destroy, inverse_of: :drone
  belongs_to :current_location, class_name: "Location", foreign_key: "current_location_id"
  belongs_to :parking_location, class_name: "Location", foreign_key: "parking_location_id"
  belongs_to :destination_location, class_name: "Location", foreign_key: "destination_location_id"


  #Enums
  enum status: [:parking, :on_mission]

  #Validations
  validates_presence_of :name, :status,:parking_location_id,:current_location_id

  # Callback
  after_commit :set_slug, on: :create
  after_initialize :set_default_current_location, unless: :persisted?

  private

  def set_slug
    Publisher.broadcast :set_drone_slug, self.id
  end

  def set_default_current_location
    self.current_location_id = self.parking_location_id
    self.destination_location_id = self.parking_location_id
  end
end
