module Railblazer
  class Gem
    def initialize(name, args)
      @name = name
      @args = args.last || {}
    end

    def for_current_platform?
      (platform?(:jruby) && ruby_platform == "java") ||
        (platform?(:mri) && ruby_platform != "java") ||
        (args[:platform].nil?)
    end

    private

    attr_accessor :args

    def platform?(platform)
      Array(args[:platform]).include?(platform)
    end

    def ruby_platform
      RUBY_PLATFORM
    end
  end
end
