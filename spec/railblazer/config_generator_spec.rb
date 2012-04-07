require 'spec_helper'

describe Railblazer::ConfigGenerator do
  describe "#to_s" do
    it "should generate a valid configuration for mysql2" do
      desired = <<EOS
test:
  adapter: mysql2
  database: fooapp_test
  username: root
  host: 127.0.0.1
EOS
      Railblazer::ConfigGenerator.new('mysql2', 'fooapp').to_s.must_equal desired
    end
  end
end
