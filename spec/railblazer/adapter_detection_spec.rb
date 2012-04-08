require 'spec_helper'

describe Railblazer::AdapterDetection do
  describe "#detect" do
    FauxGemfile = Struct.new(:gems)

    it "should detect mysql" do
      gemfile = FauxGemfile.new(%w[mysql othergem].to_set)
      Railblazer::AdapterDetection.new(gemfile).run.must_equal 'mysql'
    end

    it "should detect postgres" do
      gemfile = FauxGemfile.new(%w[othergem pg].to_set)
      Railblazer::AdapterDetection.new(gemfile).run.must_equal 'postgresql'
    end

    it "should raise an exception when more than one db gem is detected" do
      gemfile = FauxGemfile.new(%w[mysql2 pg].to_set)

      assert_raises RuntimeError do
        Railblazer::AdapterDetection.new(gemfile).run
      end
    end

    it "should raise an exception when there was no db gem detected" do
      gemfile = FauxGemfile.new(%w[thor rails].to_set)

      assert_raises RuntimeError do
        Railblazer::AdapterDetection.new(gemfile).run
      end
    end
  end
end
