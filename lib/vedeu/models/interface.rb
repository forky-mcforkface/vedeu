module Vedeu

  # An Interface represents a portion of the terminal defined by
  # {Vedeu::Geometry}. It is a container for {Vedeu::Line} and {Vedeu::Stream}
  # objects.
  class Interface

    include Coercions
    include Common
    include Presentation

    extend Forwardable

    def_delegators :geometry, :north, :east, :south, :west, :top, :right,
                              :bottom, :left, :width, :height, :origin,
                              :viewport_width, :viewport_height

    attr_reader :attributes, :delay, :group, :name, :parent

    # Builds up a new Interface object and returns the attributes.
    #
    # @param  attributes [Hash]
    # @param  block [Proc]
    # @return [Hash]
    def self.build(attributes = {}, &block)
      new(attributes, &block).attributes
    end

    # @see Vedeu::API#interface
    # @param attributes [Hash]
    # @param block [Proc]
    # @return []
    def self.define(attributes = {}, &block)
      new(attributes).define(&block)
    end

    # Return a new instance of Interface.
    #
    # @param  attributes [Hash]
    # @param  block [Proc]
    # @return [Interface]
    def initialize(attributes = {}, &block)
      @attributes = defaults.merge!(attributes)

      @name  = @attributes[:name]
      @group = @attributes[:group]
      @delay = @attributes[:delay]
      @parent = @attributes[:parent]

      if block_given?
        @self_before_instance_eval = eval('self', block.binding)

        instance_eval(&block)
      end
    end

    # @see Vedeu::API#interface
    # @param block [Proc]
    # @return [Interface]
    def define(&block)
      instance_eval(&block) if block_given?

      validate_attributes!

      Vedeu::Buffers.create(attributes)

      self
    end

    # Returns a collection of lines associated with this interface.
    #
    # @return [Array]
    def lines
      @lines ||= Line.coercer(attributes[:lines])
    end

    # @return [Geometry]
    def geometry
      @geometry ||= Geometry.new(attributes[:geometry])
    end

    # @return [String]
    def cursor
      @cursor ||= if attributes[:cursor] == true
        Esc.string('show_cursor')

      else
        Esc.string('hide_cursor')

      end
    end

    # @return [String]
    def to_s
      Render.call(self)
    end

    # @param options [Hash]
    # @return [String]
    def render(options = {})
      Render.call(self, options)
    end

    # @return [String]
    def clear
      Clear.call(self)
    end

    private

    # The default values for a new instance of Interface.
    #
    # @api private
    # @return [Hash]
    def defaults
      {
        name:     '',
        group:    '',
        lines:    [],
        colour:   {},
        style:    '',
        geometry: {},
        cursor:   true,
        delay:    0.0,
        parent:   nil,
      }
    end

    # At present, validates that an interface or view has a name attribute.
    #
    # @api private
    # @return [TrueClass|FalseClass]
    def validate_attributes!
      unless defined_value?(attributes[:name])
        fail InvalidSyntax, 'Interfaces and views must have a `name`.'
      end
    end

    # Returns the out of bounds error message for the given named attribute.
    #
    # @api private
    # @param name [String]
    # @return [String]
    def out_of_bounds(name)
      "Note: For this terminal, the value of '#{name}' may lead to content " \
      "that is outside the viewable area."
    end

    # Checks the value is within the terminal's confines.
    #
    # @api private
    # @return [TrueClass|FalseClass]
    def y_out_of_bounds?(value)
      value < 1 || value > Terminal.height
    end

    # Checks the value is within the terminal's confines.
    #
    # @api private
    # @return [TrueClass|FalseClass]
    def x_out_of_bounds?(value)
      value < 1 || value > Terminal.width
    end

    # @api private
    # @return []
    def method_missing(method, *args, &block)
      @self_before_instance_eval.send(method, *args, &block)
    end

  end
end
