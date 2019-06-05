# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Location
location_atrributes = [
    { name: "Warehouse 1", latitude: -18.91,longitude: 47.52 },
    { name: "Warehouse 2", latitude: 19.12,longitude: 72.91 },
    { name: "Warehouse 3", latitude: 46.823089,longitude: 8.032689 },
    { name: "BL Houes", latitude: 48.38583,longitude: 3.03111 },
    { name: "BL Houes 2", latitude: 19.218330,longitude: 72.978088 },
    { name: "Scripbox", latitude: 19.109490,longitude: 72.870400 },

]

location_atrributes.each do |attributes|
  Location.where(attributes).first_or_create
end

# Warehouse
location_1 =  Location.find_by_name("Warehouse 1")
location_2 = Location.find_by_name("Warehouse 2")
location_3 = Location.find_by_name("Warehouse 3")

warehouse_atrributes = [
    { name: "Warehouse 1", origin_location_id: location_1.id },
    { name: "Warehouse 2", origin_location_id: location_2.id  },
    { name: "Warehouse 3", origin_location_id: location_3.id }
]
warehouse_atrributes.each do |attributes|
  Warehouse.where(attributes).first_or_create
end

# Drone
drone_atrributes = [
    { name: "Alpha", description: "Very fast drone",destination_location_id:location_1.id,current_location_id: location_1.id ,parking_location_id: location_1.id,battery_voltage: 100,battery_level: 5,battery_current: 100},
    { name: "Beta", description: "Very fast drone" ,destination_location_id:location_1.id,current_location_id: location_1.id ,parking_location_id: location_1.id,battery_voltage: 100,battery_level: 5,battery_current: 100},
    { name: "Gamma", description: "Very fast drone" ,destination_location_id:location_1.id,current_location_id: location_1.id,parking_location_id: location_1.id,battery_voltage: 100,battery_level: 5,battery_current: 100}
]
drone_atrributes.each do |attributes|
  Drone.where(attributes).first_or_create
end