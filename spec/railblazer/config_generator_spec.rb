require 'spec_helper'

describe Railblazer::ConfigGenerator do
  describe "#interpolate" do
    it "should generate a valid configuration for mysql2" do
      desired = <<EOS
test:
  adapter: mysql2
  database: fooapp_test
  username: root
  host: 127.0.0.1
EOS
      Railblazer::ConfigGenerator.new('mysql2').interpolate({app_name: 'fooapp'}).must_equal desired
    end
  end
end
