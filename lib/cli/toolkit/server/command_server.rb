require 'drb'
require_relative 'service_discovery'

module CliToolkit::Server
  class CommandServer
    def initialize
      @server = DRb.start_service('druby://localhost:0', self)
      @port = URI(@server.uri).port

    end

    def commands

    end

    def start

    end

  end
end