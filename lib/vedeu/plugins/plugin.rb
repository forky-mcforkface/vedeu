module Vedeu

  # A class responsible for plugin loading.
  #
  class Plugin

    # @!attribute [r] name
    # @return [String]
    attr_reader :name

    # @!attribute [r] gem
    # @return [String]
    attr_reader :gem

    # @!attribute [r] gem_name
    # @return [String]
    attr_reader :gem_name

    # @!attribute [rw] enabled
    # @return [Boolean]
    attr_accessor :enabled
    alias_method :enabled?, :enabled

    # Returns a new instance of Vedeu::Plugin.
    #
    # @param name [String] The plugin name.
    # @param gem [Gem::Specification] The RubyGems gem.
    # @return [Vedeu::Plugin]
    def initialize(name, gem)
      @name     = name
      @gem      = gem
      @gem_name = "vedeu-#{name}"
      @enabled  = false
    end

    # Load the plugin (require the gem).
    #
    # @return [void]
    def load!
      begin
        require gem_name unless enabled?
      rescue LoadError => error
        fail VedeuError, "Unable to load plugin #{gem_name} due to #{error}."
      rescue => error
        fail VedeuError, "require '#{gem_name}' failed with #{error}."
      end

      @enabled = true
    end

  end # Plugin

end # Vedeu
