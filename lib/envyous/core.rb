
require 'confickle'

module Envyous
  class EnvironmentNotSpecified < Exception
  end

  class EnvironmentNameIsEmpty < Exception
  end

  class EnvironmentRootDoesNotExist < Exception
  end

  def self.config(options)
    c = Context.new(options)

    retval = c.confickle

    unless File.exists?(retval.root)
      raise EnvironmentRootDoesNotExist.new(retval.root)
    end

    retval
  end


  class Context

    # The root config folder.  Contains the
    # config folders for all environments.
    attr_reader :root

    # Name of the environment variable that will
    # be used as the environment switch.
    #
    #  Default value:  'ENV'
    #
    attr_reader :env_var


    # Options that will be passed to confickle.
    # Note: Envyous will override the :root option.
    attr_reader :confickle_opts

    def initialize(options)
      if options.is_a? String
        options = {root: options}
      end

      @root           = options.fetch(:root)
      @env_var        = options.fetch(:env_var, 'ENV').to_s
      @confickle_opts = options.fetch(:confickle_opts, {})
    end

    def envyous_opts
      @envyous_opts ||= begin
        File.open(File.join(root, "envyous.json")) do |fin|
          JSON.parse(fin.read, symbolize_names: true)
        end
      end
    end



    def env_name
      @env_name ||= begin
        name = ENV.fetch(env_var) do
          envyous_opts.fetch(:env) do
            raise EnvironmentNotSpecified
          end
        end

        if name.empty?
          raise EnvironmentNameIsEmpty
        end

        name
      end
    end


    def confickle_root
      @confickle_root ||= File.join(root, "environments", env_name)
    end

    def confickle
      opts = confickle_opts.merge(
        root: confickle_root
      )

      Confickle.new(opts)
    end
  end

end
