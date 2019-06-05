Rails.application.config.to_prepare do
  Wisper.clear if Rails.env.development?
  Wisper.subscribe(WarehouseListener)
  Wisper.subscribe(DroneListener)
  Wisper.subscribe(MissionListener)
end
