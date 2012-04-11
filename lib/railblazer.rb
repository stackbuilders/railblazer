$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

require 'extensions/hash'
require 'railblazer/auto_configure/cli'
require 'railblazer/adapter_detection'
require 'railblazer/minimal_gemfile'
require 'railblazer/template'
