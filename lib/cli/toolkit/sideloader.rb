# frozen_string_literal: true

require_relative "../version"
require_relative "./refinements/thor_subcommand_registry"
require "thor"

module CliToolkit
  class Sideloader
    attr_reader :cli_klass, :gem_name, :path

    using CliToolkit::Refinements::ThorSubcommandRegistry

    def initialize(cli_klass:, gem_name:, path:)
      @cli_klass = cli_klass
      @gem_name = gem_name
      @path = path
    end

    def register_local_command(local_command_description:)
      details = local_command_description[:details]
      subcommand_klass = local_command_description[:commands_klass]

      cli_klass.class_eval do
        namespace details[:name].to_sym
        desc details[:usage], details[:desc]
        subcommand commands_klass: subcommand_klass, details: details
      end
    end

    def register_command_gem(gem_name:)
      Object.const_get("#{to_studly(gem_name)}::Register").().map do |registration|
        cli_klass.class_eval do
          namespace registration[:details].name.to_sym
          desc registration[:details].usage, registration[:details].description
          subcommand commands_klass: registration[:command_klass], details: registration[:details].to_h
        end
      end
    end

    def load
      require gem_name

      register_command_gem(gem_name: gem_name)

    rescue NameError => e
      case e.message
      when /uninitialized constant #{to_studly(gem_name)}::Register/
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

    private

    def to_studly(string)
      string.split("_").map(&:capitalize).join
    end

    def rubygem?
      @path.nil?
    end
  end
end

