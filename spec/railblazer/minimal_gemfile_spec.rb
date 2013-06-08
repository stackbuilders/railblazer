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
        gem 'pg', platform: :jruby
        group 'development' do
          gem 'othergem'
        end
      EOF

      Railblazer::MinimalGemfile.new(StringIO.new(mysql_gemfile)).gems.must_equal %w[mysql othergem].to_set
    end

    it "should detect for the current platform" do
      pg_gemfile = <<-EOF
        gem 'mysql', platform: :mri
        gem 'pg', platform: :jruby
        group 'development' do
          gem 'othergem'
        end
      EOF

      Railblazer::Gem.any_instance.stubs(:current_ruby_platform).returns("java")
      Railblazer::MinimalGemfile.new(StringIO.new(pg_gemfile)).gems.must_equal %w[pg othergem].to_set
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

    it "should work with gems with other options" do
      versioned_gemfile = <<-EOF
        gem 'shoulda-matchers', '~> 1.3.0'
        gem 'plastic', git: 'git://github.com/square/plastic.git', ref: '75b701c3b90b7057c7b3daf89e01cec5b0e7dde'
      EOF

      Railblazer::MinimalGemfile.new(StringIO.new(versioned_gemfile)).gems.must_equal %w[shoulda-matchers plastic].to_set
    end

    it "should respond_to methods that aren't defined" do
      assert_respond_to Railblazer::MinimalGemfile.new(StringIO.new('')), :foobar
    end
  end
end

