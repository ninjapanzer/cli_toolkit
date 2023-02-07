module CliToolkit::Refinements
  module ToStudly
    refine String do
      def self.to_studly
        split("_").map(&:capitalize).join
      end
    end
  end
end
