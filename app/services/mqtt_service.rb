class MqttService

  attr_reader :client

  def initialize
    @client = MQTT::Client.new({:host => APP_CONFIG["mqtt"]["end_point"], :port => APP_CONFIG["mqtt"]["port"],:keep_alive => 15})
  end

  def connect_to_broker
    @client.connect
    subscribe
    receive
  end

  def subscribe
    #sensors/alpha/altitude
    @client.subscribe("sensors/alpha/altitude")
    #Drone.all.each do |drone|
      #@client.subscribe("sensors/#{drone.name.downcase}/altitude")
    #end
    Rails.logger.info "connected"
  end

  def receive
    Thread.new do
      @client.get do |drone, message|
        DroneLog.info  "#{drone}: #{message}"
        ::Publisher.broadcast :reply_from_drone, message
      end
    end
  end

end
