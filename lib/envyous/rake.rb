require 'rake'

require 'fileutils'

module Envyous
  module Rake
    extend ::Rake::DSL

    class AlreadyInitialized < Exception
    end

    class ConfigInitializer
      attr_reader :src, :dest

      def initialize(options = {})
        @dest  = options.fetch(:dest)
        @src   = options[:src]

        unless @src
          @src = "#{dest}.template"
        end
      end

      def init(force = false)
        if File.exists?(dest)
          if force
            FileUtils.rm_rf dest
          else
            raise AlreadyInitialized
          end
        end

        FileUtils.cp_r src, dest
      end

      def soft_init
        unless File.exists? dest
          FileUtils.cp_r src, dest
        end
      end

    end


    def self.default!(options = {})
      namespace :config do 
        create_tasks!(options)
      end
    end

    def self.create_tasks!(options = {})
      cfg_init = ConfigInitializer.new(options)

      desc "Initializes envyous config"
      task :init do
        cfg_init.init(ENV['force'] == "true")
      end

      desc "Soft-initializes envyous config"
      task :soft_init do
        cfg_init.soft_init
      end
    end

  end
end
