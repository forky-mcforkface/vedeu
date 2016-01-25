# frozen_string_literal: true

module Vedeu

  module Coercers

    # Provides the mechanism to convert a value into a
    # {Vedeu::Views::Lines}.
    #
    # @api private
    #
    class Lines < Vedeu::Coercers::Coercer

      # @return [void]
      def coerce
        if coerced?
          value

        else


        end
      end

      private

      # @return [Class]
      def klass
        Vedeu::Views::Lines
      end

    end # Lines

  end # Coercers

end # Vedeu