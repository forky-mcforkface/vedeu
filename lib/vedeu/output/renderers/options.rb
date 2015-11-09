module Vedeu

  module Renderers

    # Provides shared functionality to Vedeu::Renderer classes.
    #
    module Options

      # :nocov:

      # @!attribute [w] options
      # @return [Hash<Symbol => void>]
      attr_writer :options

      def compress?
        options[:compression] || false
      end

      private

      # Combines the options provided at instantiation with the
      # default values.
      #
      # @return [Hash<Symbol => void>]
      def options
        defaults.merge!(@options)
      end

      # The default values for a new instance of this class.
      #
      # @return [Hash<Symbol => void>]
      def defaults
        {}
      end

      # :nocov:

    end # Options

  end # Renderers

end # Vedeu
