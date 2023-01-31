require_relative "../version"

module CliToolkit::Registry
  def self.register(commands_klass:, details:)
    @registry ||= []
    @registry << { commands_klass: commands_klass, details: details }
  end

  def self.commands
    @registry
  end

  def self.reset!
    clone = @registry.dup
    @registry = []
    clone
  end
end

