require 'vedeu/support/common'

module Vedeu

  module DSL

    # Provides methods to be used to define keypress mapped to actions.
    #
    # @api public
    class Keymap

      include Vedeu::Common

      # Returns an instance of DSL::Keymap.
      #
      # @param model [Keymap]
      def initialize(model)
        @model = model
      end

      # Define keypress(es) to perform an action.
      #
      # @param value_or_values [String|Symbol] The key(s) pressed. Special keys
      #   can be found in {Vedeu::Input#specials}. When more than one key is
      #   defined, then the extras are treated as aliases.
      # @param block [Proc] The action to perform when this key is pressed. Can
      #   be a method call or event triggered.
      #
      # @example
      #   keys do
      #     key('s')        { Vedeu.trigger(:save) }
      #     key('h', :left) { Vedeu.trigger(:left) }
      #     key('j', :down) { Vedeu.trigger(:down) }
      #     key('p') do
      #       ...
      #     end
      #     ...
      #
      # @raise [InvalidSyntax] When the required block is not given, the
      #   value_or_values parameter is undefined, or when processing the
      #   collection, a member is undefined.
      # @return [Array] A collection containing the keypress(es).
      def key(*value_or_values, &block)
        unless block_given?
          fail InvalidSyntax, 'No action defined for `key`.'
        end

        unless defined_value?(value_or_values)
          fail InvalidSyntax, 'No keypress(es) defined for `key`.'
        end

        value_or_values.each do |value|
          unless defined_value?(value)
            fail InvalidSyntax, 'An invalid value for `key` was encountered.'
          end

          @model = model.define(value, block)
        end
      end

      private

      attr_reader :model

    end # Keymap

  end # DSL

end # Vedeu
