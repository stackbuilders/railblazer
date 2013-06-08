require 'spec_helper'

describe Railblazer::Gem do
  describe "#for_current_platform?" do
    it "returns true if ruby platform is Java and gem platform is jruby" do
      gem = Railblazer::Gem.new([{platform: :jruby}])
      gem.stubs(:current_ruby_platform).returns("java")
      gem.for_current_platform?.must_equal true
    end

    it "returns false if ruby platform is Java and gem platform is mri" do
      gem = Railblazer::Gem.new([{platform: :mri}])
      gem.stubs(:current_ruby_platform).returns("java")
      gem.for_current_platform?.must_equal false
    end

    it "returns true if ruby platform is not Java and gem platform is mri" do
      gem = Railblazer::Gem.new([{platform: :mri}])
      gem.stubs(:current_ruby_platform).returns("something_entirely_different")
      gem.for_current_platform?.must_equal true
    end

    it "returns false if ruby platform is not Java and gem platform is jruby" do
      gem = Railblazer::Gem.new([{platform: :jruby}])
      gem.stubs(:current_ruby_platform).returns("something_entirely_different")
      gem.for_current_platform?.must_equal false
    end

    it "returns true if no gem platform is specified" do
      gem = Railblazer::Gem.new([])
      gem.stubs(:current_ruby_platform).returns("java")
      gem.for_current_platform?.must_equal true
    end

    it "works when platform is an array" do
      gem = Railblazer::Gem.new([{platform: [:jruby]}])
      gem.stubs(:current_ruby_platform).returns("java")
      gem.for_current_platform?.must_equal true
    end

    it "works when the initialization array last element is not a hash" do
      gem = Railblazer::Gem.new(["~> 1.3.0"])
      gem.stubs(:current_ruby_platform).returns("java")
      gem.for_current_platform?.must_equal true
    end
  end
end
