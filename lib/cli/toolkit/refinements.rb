require_relative "../version"

module CliToolkit
  class Error < StandardError; end
  module Refinements; end
end

require_relative "../toolkit/refinements/thor_subcommand_registry"
require_relative "../toolkit/refinements/to_studly"
