namespace :mqtt_start do
  task connect_to_mqtt: :environment do
    MqttService.new.connect_to_broker
  end
end
