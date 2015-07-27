module Vedeu

  module Templating

    # Converts an encoded string back into an object or objects.
    #
    class Decoder

      # @param data [String]
      # @return [Object]
      def self.process(data)
        new(data).process
      end

      # Returns a new instance of Vedeu::Templating::Decoder.
      #
      # @param data [String]
      # @return [Vedeu::Templating::Decoder]
      def initialize(data)
        @data = data
      end

      # @return [Object]
      def process
        demarshal
      end

      protected

      # @!attribute [r] data
      # @return [String]
      attr_reader :data

      private

      # Convert the marshalled object or objects back into an object(s).
      #
      # @return [Object]
      def demarshal
        Marshal.load(decompress)
      end

      # Decompress the marshalled object or objects.
      #
      # @return [String]
      def decompress
        Zlib::Inflate.inflate(decode64)
      end

      # Decode the Base64 string into a compressed, marshalled object or
      # objects.
      #
      # @return [String]
      def decode64
        Base64.strict_decode64(data)
      end

    end # Decoder

  end # Templating

end # Vedeu