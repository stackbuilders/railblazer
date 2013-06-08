require 'set'

module Railblazer
  class MinimalGemfile
    attr_reader :gems

    def initialize gemfile
      @gems = Set.new
      instance_eval gemfile.read
    end

    def gem name, *args
      @gems << name if gem_for_current_platform?(args)
    end

    def group *args, &block
      yield
    end

    def respond_to_missing? method, *args
      true
    end

    def method_missing name, *args ; end

    private

    def gem_for_current_platform?(options)
      Gem.new(options).for_current_platform?
    end
  end
end
