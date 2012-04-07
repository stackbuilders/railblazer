require 'erb'
require 'etc'

module Railblazer
  class ConfigGenerator

    HOME_TEMPLATE_PATH = "#{Etc.getpwuid.dir}/.blaze/templates"

    attr_reader :db_adapter, :app_name
    def initialize db_adapter, app_name
      @db_adapter = db_adapter
      @app_name   = app_name
    end

    def to_s
      ERB.new(template).result(binding)
    end

    private
    def template
      selected_template = File.join(template_path, "#{db_adapter}.yml.erb")
      raise "Template file not found for #{db_adapter}" unless File.exist?(selected_template)
      template = File.read(selected_template)
    end

    def template_path
      File.directory?(HOME_TEMPLATE_PATH) ? 
        HOME_TEMPLATE_PATH :
        File.join(File.dirname(__FILE__), '../../templates')
    end
  end
end