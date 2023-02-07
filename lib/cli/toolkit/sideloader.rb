# frozen_string_literal: true

require_relative "../version"
require_relative "./refinements/thor_subcommand_registry"
require "thor"

module CliToolkit
  class Sideloader
    using CliToolkit::Refinements::ToStudly

    attr_reader :cli_klass, :gem_name, :path

    using CliToolkit::Refinements::ThorSubcommandRegistry

    private_class_method :new
    def initialize(cli_klass:, gem_name:, path:)
      @cli_klass = cli_klass
      @gem_name = gem_name
      @path = path
    end

    def self.load_command(cli_klass:)
      new(cli_klass: cli_klass, gem_name: nil, path: nil)
    end

    def self.import_gem_commands(cli_klass:, gem_name:, path:)
      new(cli_klass: cli_klass, gem_name: gem_name, path: path)
    end

    def register_commands(command_description:)
      details = command_description[:details]
      subcommand_klass = command_description[:commands_klass]

      cli_klass.class_eval do
        namespace details[:name].to_sym
        desc details[:usage], details[:desc]
        subcommand commands_klass: subcommand_klass, details: details
      end
    end

    def load_command_gem
      load_gem

      CliToolkit::Registry.reset!.map do |gem_command|
        CliToolkit::Sideloader.load_command(cli_klass: cli_klass).register_commands(command_description: gem_command)
      end
    end

    private

    def load_gem
      require gem_name
    rescue NameError => e
      case e.message
      when /uninitialized constant #{gem_name.to_studly}::Register/
        puts("Sideload configured #{gem_name} is not side loadable, Consider uninstalling it")
      else
        puts("something is wrong with extension \#{gem_name}")
        raise e
      end

    rescue LoadError => e
      puts("#{gem_name} is not found in specified path: #{e}. You might wanna fetch it first.")
    rescue e
      puts("haha")
    end

    def rubygem?
      @path.nil?
    end
  end
end
