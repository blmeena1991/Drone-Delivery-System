module PublishToMqtt
  class << self

    def mission_start_by_drone(mission_id)
      @mission = Mission.find(mission_id)
      message = {
          "mission_id": mission_id,
          "parcel_info": {
              "parcel_id": @mission.parcel.id,
              "weight": @mission.parcel.weight,
              "recipient_name": @mission.parcel.recipient_name,
          },
          "warehouse_location": {
              "latitude": @mission.warehouse.origin_location.latitude,
              "longitude": @mission.warehouse.origin_location.longitude
          },
          "destination_location": {
              "latitude": @mission.parcel.destination_location.latitude,
              "longitude": @mission.parcel.destination_location.longitude
          }
      }
      send_to_mqtt(message)
    end

    private
    def send_to_mqtt(message)
      # creates the client connection
      #@client ||= MQTT::Client.connect(host: APP_CONFIG["mqtt"]["end_point"], port: APP_CONFIG["mqtt"]["port"],keep_alive: 15)
      @client = MQTT::Client.new({:host => APP_CONFIG["mqtt"]["end_point"], :port => APP_CONFIG["mqtt"]["port"],:keep_alive => 15})
      @client.connect
      # publishes on drone wise output topic
      @client.publish("sensors/#{@mission.drone.name.downcase}/altitude", message)
    end
  end
end



