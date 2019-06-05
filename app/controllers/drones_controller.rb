class DronesController < ApplicationController
  before_action :set_drone, only: [:show]

  def show
    json_response(@drone.as_json(:include=>[:current_location,:parking_location,:destination_location]))
  end
  private

  def set_drone
    @drone = Drone.includes(:current_location,:parking_location,:destination_location).find(params[:id])
  end
end
