class Warehouse < ApplicationRecord
  #Associations
  belongs_to :origin_location, class_name: "Location", foreign_key: "origin_location_id"
  has_many :missions, dependent: :destroy, inverse_of: :warehouse

  #Validations
  validates_presence_of :name,:origin_location_id

  # Callback
  after_commit :set_slug, on: :create

  private

  def set_slug
    Publisher.broadcast :set_warehouse_slug, self.id
  end
end
