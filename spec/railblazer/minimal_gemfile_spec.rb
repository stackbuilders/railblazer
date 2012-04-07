require 'spec_helper'
require 'set'
require 'stringio'

describe Railblazer::MinimalGemfile do
  describe "#gems" do
    it "should read a flat list of gems" do
      mysql_gemfile = <<-EOF
        gem 'mysql'
        gem 'othergem'
      EOF

      Railblazer::MinimalGemfile.new(StringIO.new(mysql_gemfile)).gems.must_equal %w[mysql othergem].to_set
    end

    it "should detect gems inside of group blocks" do
      mysql_gemfile = <<-EOF
        gem 'mysql'
        group 'development' do
          gem 'othergem'  
        end
      EOF

      Railblazer::MinimalGemfile.new(StringIO.new(mysql_gemfile)).gems.must_equal %w[mysql othergem].to_set
    end

    it "should ignore other methods in the Gemfile" do
      mysql_gemfile = <<-EOF
        gem 'mysql'
        funky_method
      
        group 'development' do
          gem 'othergem'  
        end
      EOF

      Railblazer::MinimalGemfile.new(StringIO.new(mysql_gemfile)).gems.must_equal %w[mysql othergem].to_set
    end
  end
end

