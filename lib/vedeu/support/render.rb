module Vedeu
  class Render

    # Attempts to convert the provided interface object with associated lines,
    # streams, colours, styles, etc, into a single string containing all content
    # and escape sequences.
    #
    # @api private
    # @param interface [Interface]
    # @param options [Hash]
    # @return [String]
    def self.call(interface, options = {})
      new(interface, options).render
    end

    # Initializes a new Render object with the provided interface.
    #
    # @param interface [Interface]
    # @param options [Hash]
    # @return [Render]
    def initialize(interface, options = {})
      @interface = interface
      @options   = options
    end

    # Produces a single string which contains all content and escape sequences
    # required to render this interface to a position in the terminal window.
    #
    # @return [String]
    def render
      out = [ Clear.call(interface) ]
      processed_lines.each_with_index do |line, index|
        out << interface.origin(index)
        out << line.to_s
      end
      out << interface.cursor
      out.join
    end

    private

    attr_reader :interface

    # The client application may have created a line that us too long for the
    # interface. This code tries to truncate streams whilst preserving styles
    # and colours.
    #
    # @api private
    # @return [Array]
    def processed_lines
      return [] unless lines.any? { |line| line.streams.any? }

      lines.map do |line|
        if exceeds_width?(line)
          line_length = 0
          processed   = []
          line.streams.each do |stream|
            next if stream.text.empty?

            if (line_length += stream.text.size) >= width
              remainder = width - line_length

              processed << Stream.new({
                             colour: stream.colour.attributes,
                             style:  stream.style.values,
                             text:   truncate(stream.text, remainder),
                           })

            else
              processed << stream

            end
          end

          Line.new({
            colour:  line.colour.attributes,
            streams: processed,
            style:   line.style.values,
          })

        else
          line

        end
      end
    end

    # Converts all streams within a line into a single line of text to then
    # check that this line (without formatting, as that is not visible) exceeds
    # the width of the interface.
    #
    # @api private
    # @param line [Line]
    # @return [TrueClass|FalseClass]
    def exceeds_width?(line)
      line.streams.map(&:text).join.size > width
    end

    # Truncates the provided text.
    #
    # @api private
    # @param text [String] The text to be truncated.
    # @param value [Fixnum] The total length of the text after truncation.
    # @return [String]
    def truncate(text, value)
      text.chomp.slice(0...value)
    end

    # Provides a collection of lines associated with the interface.
    # If the option `:top` was set, we will start at that line. Any lines
    # outside of the height will not be rendered.
    #
    # @api private
    # @return [Array]
    def lines
      interface.lines[top..height]
    end

    # Provides the currently available height of the interface.
    #
    # @note The height is reported to be one less line than actual because
    #   terminal coordinates count from 1, not 0.
    #
    # @api private
    # @return [Fixnum]
    def height
      interface.viewport_height - 1
    end

    # Provides the currently available width of the interface.
    #
    # @api private
    # @return [Fixnum]
    def width
      interface.viewport_width
    end

    # The current top line.
    #
    # @api private
    # @return [Fixnum]
    def top
      options[:top]
    end

    # @api private
    # @return [Hash]
    def options
      @_options ||= defaults.merge!(@options)
    end

    # @api private
    # @return [Hash]
    def defaults
      {
        top: 0
      }
    end

  end
end
