require 'set'

module Railblazer
  class MinimalGemfile
    attr_reader :gems

    def initialize gemfile
      @gems = Set.new
      instance_eval gemfile.read
    end

    def gem name, *args
      @gems << name
    end

    def group *args, &block
      yield
    end

    def respond_to_missing? method, *args
      true
    end

    def method_missing name, *args ; end
  end
end
