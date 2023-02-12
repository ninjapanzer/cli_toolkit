module CliToolkit::Server
  class DiscoveryServer
    def initialize
      @registered = false
    end

    def register(service_name, service_url, service_port, service_description)
      puts "registered"
      puts service_name
      puts service_url
      puts service_port
      puts service_description

      @registered = true
      DRb.stop_service
      @registered
    end

    def start
      @server = DRb.start_service('druby://localhost:9100', self)
      puts "Server PID is #{Process.pid}"
    end
  end
end