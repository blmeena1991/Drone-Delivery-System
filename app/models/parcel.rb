class Parcel < ApplicationRecord
  #Associations
  has_one :mission
  belongs_to :destination_location, class_name: "Location", foreign_key: "destination_location_id"

  #Validations
  validates_presence_of :recipient_name,:weight,:destination_location_id
end
