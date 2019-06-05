class Location < ApplicationRecord
  #Validations
  validates_presence_of :name, :latitude,:longitude
end
