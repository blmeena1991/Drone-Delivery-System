class MissionsController < ApplicationController
  before_action :set_mission, only: [:show]

  def show
    json_response(@mission.as_json(:include=>[:drone,:warehouse,:parcel]))
  end
  private

  def set_mission
    @mission = Mission.includes(drone: [:current_location,:parking_location,:destination_location], warehouse: :origin_location,parcel: :destination_location).find(params[:id])
  end
end
