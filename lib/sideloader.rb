# frozen_string_literal: true

require 'zeitwerk'

require_relative "cli/version"

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.setup
# loader.eager_load_namespace()

module CliToolkit
  class Error < StandardError; end
  # Your code goes here...
end
