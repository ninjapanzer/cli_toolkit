module Cli::SubcommandRegistry
  Registry ||= Module.new do
    def self.register(commands_klass:, details:)
      @registry ||= []
      @registry << { commands_klass: commands_klass, details: details }
    end

    def self.commands
      @registry
    end
  end
end
