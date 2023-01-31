require 'zeitwerk'

require_relative "cli/version"

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.setup

