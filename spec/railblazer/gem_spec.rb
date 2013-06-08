require 'spec_helper'

describe Railblazer::Gem do
  describe "#for_current_platform?" do
    it "returns true if ruby platform is Java and gem platform is jruby" do
      gem = Railblazer::Gem.new("pg", [{platform: :jruby}])
      gem.stubs(:ruby_platform).returns("java")
      gem.for_current_platform?.must_equal true
    end

    it "returns false if ruby platform is Java and gem platform is mri" do
      gem = Railblazer::Gem.new("pg", [{platform: :mri}])
      gem.stubs(:ruby_platform).returns("java")
      gem.for_current_platform?.must_equal false
    end

    it "returns true if ruby platform is not Java and gem platform is mri" do
      gem = Railblazer::Gem.new("pg", [{platform: :mri}])
      gem.stubs(:ruby_platform).returns("something_entirely_different")
      gem.for_current_platform?.must_equal true
    end

    it "returns false if ruby platform is not Java and gem platform is jruby" do
      gem = Railblazer::Gem.new("pg", [{platform: :jruby}])
      gem.stubs(:ruby_platform).returns("something_entirely_different")
      gem.for_current_platform?.must_equal false
    end

    it "returns true if no gem platform is specified" do
      gem = Railblazer::Gem.new("pg", [])
      gem.stubs(:ruby_platform).returns("java")
      gem.for_current_platform?.must_equal true
    end

    it "works when platform is an array" do
      gem = Railblazer::Gem.new("pg", [{platform: [:jruby]}])
      gem.stubs(:ruby_platform).returns("java")
      gem.for_current_platform?.must_equal true
    end
  end
end
