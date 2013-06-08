module Railblazer
  class Gem
    def initialize(args)
      @args = args.last
    end

    def for_current_platform?
      gem_platforms.empty? ||
        (gem_platform?(:jruby) && current_ruby_platform == "java") ||
        (gem_platform?(:mri) && current_ruby_platform != "java")
    end

    private

    attr_accessor :args

    def gem_platform?(platform)
      gem_platforms.include? platform
    end

    def gem_platforms
      if args.is_a? Hash
        Array(args[:platforms])
      else
        []
      end
    end

    def current_ruby_platform
      RUBY_PLATFORM
    end
  end
end
