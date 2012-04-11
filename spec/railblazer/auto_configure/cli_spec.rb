require 'spec_helper'

describe Railblazer::AutoConfigure::CLI do
  describe "#start" do
    it "should create a database configuration file" do
      gemfile = stub(:gems => ['mysql2'].to_set)

      cli = Railblazer::AutoConfigure::CLI.new('root', 'app', gemfile, :dry_run => true)
      cli.expects(:output).with('config/database.yml', regexp_matches(/mysql2/))

      cli.start
    end

    it "should create a sunspot configuration file when sunspot_rails is in the gemfile" do
      gemfile = stub(:gems => ['mysql2', 'sunspot_rails'].to_set)

      cli = Railblazer::AutoConfigure::CLI.new('root', 'app', gemfile, :dry_run => true)
      cli.expects(:output).with('config/database.yml', regexp_matches(/mysql2/))
      cli.expects(:output).with('config/sunspot.yml', regexp_matches(/solr/))

      cli.start
    end

    it "should create a resque configuration file" do
      gemfile = stub(:gems => ['mysql2', 'resque'].to_set)

      cli = Railblazer::AutoConfigure::CLI.new('root', 'app', gemfile, :dry_run => true)
      cli.expects(:output).with('config/database.yml', regexp_matches(/mysql2/))
      cli.expects(:output).with('config/initializers/z_ci_resque.rb', regexp_matches(/Redis.new/))

      cli.start      
    end

    it "should output to the file when dry_run is false" do
      gemfile = stub(:gems => ['mysql2'].to_set)

      cli = Railblazer::AutoConfigure::CLI.new('root', 'app', gemfile, :dry_run => false)
      cli.expects(:output_to_file)

      cli.start
    end
  end
end
