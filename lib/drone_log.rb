class DroneLog
  LogFile = Rails.root.join('log', 'drone.log')
  class << self
    cattr_accessor :logger
    delegate :debug, :info, :warn, :error, :fatal, :to => :logger
  end
end