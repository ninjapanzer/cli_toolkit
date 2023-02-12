module Toolkit::Server
  class Error < StandardError; end

  class ServiceDiscovery
    def initialize(service_name:, service_url:, service_port:, service_description:)
      @service_name = service_name
      @service_url = service_url
      @service_port = service_port
      @service_description = service_description
      @registered = false
      puts "hi"
    end

    def broadcast(service_name, service_url, service_port, service_description)
      puts "broadcasting"
      response = DRbObject.new_with_uri("druby://localhost:9100")
      response.register(service_name, service_url, service_port, service_description)
      true
    rescue => e
      puts e
      puts "Server is not running waiting"
      false
    end

    def register
      puts "registering"
      loop do
        server = DRb.start_service('druby://localhost:0', self)
        @registered = DRbObject.new_with_uri(server.uri).broadcast(@service_name, @service_url, @service_port, @service_description)
        server.stop_service
        break if @registered
        sleep 5
        DRb.start_service('druby://localhost:0', self)
      end
    end
  end
end