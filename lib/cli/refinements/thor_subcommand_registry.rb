require 'thor'
require_relative '../subcommand_registry/registry'

module Cli::Refinements
  class ThorSubcommandRegistry
    refine Thor.singleton_class do
      def subcommand(commands_klass:, details: {})
        details[:desc] ||= @desc
        details[:name] ||= @usage
        details[:usage] ||= @usage
        details[:long_desc] ||= @long_desc

        Cli::SubcommandRegistry::Registry.register(commands_klass: commands_klass, details: details)
        super(details[:name], commands_klass)
      end
    end
  end
end