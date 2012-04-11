require 'optparse'

module Railblazer
  module AutoConfigure
    class CLI

      BANNER = "Usage is auto_configure RAILS_ROOT APP_OR_BUILD_NAME"

      def self.start
        if ARGV.empty?
          puts BANNER
          exit 1
        end

        raise ArgumentError, "App name must be specified as second parameter" if ARGV[1].nil?

        options = parse_options
        gemfile = Railblazer::MinimalGemfile.new(File.new(File.join(rails_root, 'Gemfile')))
        new(ARGV[0], ARGV[1], gemfile, options).start
      end

      def self.parse_options
        options = {:dry_run => false}
        OptionParser.new do |opts|
          opts.banner = BANNER
          
          opts.on("-d", "--[no-]dry-run", "Output to screen instead of configuration files") do |d|
            options[:dry_run] = d
          end
        end.parse!

        options
      end

      attr_reader :rails_root, :app_name, :gemfile, :options

      def initialize rails_root, app_name, gemfile, options = { }
        @rails_root = rails_root
        @app_name   = app_name
        @gemfile    = gemfile
        @options    = options
      end

      def start
        write_sunspot_configuration!
        write_database_configuration!
        write_resque_configuration!
      end


      private

      def write_database_configuration!
        output('config/database.yml', Railblazer::Template.new(db_adapter).interpolate({app_name: app_name})) 
      end

      def db_adapter
        Railblazer::AdapterDetection.new(gemfile).run
      end

      def write_sunspot_configuration!
        if gemfile.gems.include?('sunspot_rails')
          output('config/sunspot.yml', Railblazer::Template.new('sunspot').interpolate({ port: random_solr_port }))
        end
      end

      def write_resque_configuration!
        if gemfile.gems.include?('resque')
          redis_config = "Resque.redis = $redis = Redis.new({ db: #{rand(0..15)} })\n"
          # Overwrite existing resque configuration by alphabetical order
          output('config/initializers/z_ci_resque.rb', redis_config)
        end
      end

      def random_solr_port
        8900 + rand(1..99)
      end

      def output(path_in_app, contents)
        dry_run? ? output_to_screen(path_in_app, contents) : output_to_file(path_in_app, contents)
      end

      def dry_run?
        options[:dry_run]
      end

      def output_to_screen(path_in_app, contents)
        puts ">> Would write #{path_in_app}:\n#{contents}\n"
      end

      def output_to_file(path_in_app, contents)
        File.open(File.join(rails_root, path_in_app, 'w')) {|file| file.write(sunspot_config)}
      end
    end
  end
end