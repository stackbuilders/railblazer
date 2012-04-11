require 'erb'
require 'etc'

module Railblazer
  class Template

    HOME_TEMPLATE_PATH = "#{Etc.getpwuid.dir}/.blaze/templates"

    def initialize template_name
      @template = ERB.new(template_for(template_name))
    end

    def interpolate replacements = { }
      @template.result(replacements.to_binding)
    end

    private
    def template_for template_name
      selected_template = File.join(template_path, "#{template_name}.yml.erb")
      raise "Template not found for #{template_name}" unless File.exist?(selected_template)
      File.read(selected_template)
    end

    def template_path
      File.directory?(HOME_TEMPLATE_PATH) ? 
        HOME_TEMPLATE_PATH :
        File.join(File.dirname(__FILE__), '../../templates')
    end
  end
end