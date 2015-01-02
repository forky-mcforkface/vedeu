require 'vedeu/dsl/dsl'

require 'vedeu/support/common'
require 'vedeu/models/model'
require 'vedeu/presentation/presentation'

module Vedeu

  # An Interface represents a portion of the terminal defined by
  # {Vedeu::Geometry}. It is a container for {Vedeu::Line} and {Vedeu::Stream}
  # objects.
  #
  # @api private
  class Interface

    extend Vedeu::DSL
    extend Forwardable

    include Vedeu::Common
    include Vedeu::Model
    include Vedeu::Presentation

    def_delegators :geometry, :north, :east,  :south,  :west,
                              :top,   :right, :bottom, :left,
                              :width, :height, :origin

    attr_reader :attributes, :delay, :parent
    attr_writer :cursor, :geometry

    attr_accessor :colour, :lines, :parent
    alias_method :content, :lines

    class << self

      include Vedeu::Common

      def build(lines = [], parent, colour, style, &block)
        model = new({ lines: lines, parent: parent, colour: colour, style: style })
        model.deputy.instance_eval(&block) if block_given?
        model
      end

      # @see Vedeu::Interface.interface
      # @param attributes [Hash]
      # @param block [Proc]
      # @return [Interface]
      def define(attributes = {}, &block)
        attrs = build(attributes, &block)

        Registrar.record(attrs)

        self
      end

      # Register an interface by name which will display output from a event or
      # command. This provides the means for you to define your application's
      # views without their content.
      #
      # @todo More documentation required.
      # @param name  [String] The name of the interface. Used to reference the
      #   interface throughout your application's execution lifetime.
      # @param block [Proc] A set of attributes which define the features of the
      #   interface.
      #
      # @example
      #   Vedeu.interface 'my_interface' do
      #     ...
      #
      #   Vedeu.interface do
      #     name 'interfaces_must_have_a_name'
      #     ...
      #
      # @return [Interface]
      def interface(name = '', &block)
        new_interface      = build(nil, nil, nil, nil, &block)
        new_interface.name = name if defined_value?(name)
        new_interface.store
      end

    end

    # Return a new instance of Interface.
    #
    # @param  attributes [Hash]
    # @param  block [Proc]
    # @return [Interface]
    def initialize(attributes = {})
      @attributes = defaults.merge(attributes)

      @border   = Border.new(self, @attributes[:border])
      @colour   = @attributes[:colour]
      @delay    = @attributes.fetch(:delay, 0.0)
      @geometry = Geometry.new(@attributes[:geometry])
      @group    = @attributes.fetch(:group, '')
      @name     = @attributes[:name]

      @lines    = Vedeu::Model::Lines.new(self, @attributes[:lines])
    end

    # @see Vedeu::API#interface
    # @param block [Proc]
    # @return [Interface]
    def define(&block)
      instance_eval(&block) if block_given?

      Registrar.record(attributes)

      self
    end

    # Returns an instance of Border.
    #
    # @return [Border]
    def border
      @border
    end

    def border=(value)
      @border = value
    end

    # Returns an instance of Cursor.
    #
    # @return [Cursor]
    def cursor
      @_cursor ||= Cursors.find_or_create(name, { visible: @cursor })
    end

    def cursor=(value)
      @cursor = value
    end

    def delay
      @delay
    end

    def delay=(value)
      @delay = value
    end

    # Returns the class responsible for defining the DSL methods of this model.
    #
    # @return [DSL::Interface]
    def deputy
      Vedeu::DSL::Interface.new(self)
    end

    # Returns the position and size of the interface.
    #
    # @return [Geometry]
    def geometry
      @geometry
    end

    def geometry=(value)
      @geometry = value
    end

    def group
      @group
    end

    def group=(value)
      @group = value
    end

    def lines
      @lines
    end

    def lines=(value)
      @lines = value
    end

    def name
      @name ||= ''
    end

    def name=(value)
      @name = value
    end

    def parent
      @parent
    end

    def parent=(value)
      @parent = value
    end

    def style
      @style
    end

    def style=(value)
      @style = value
    end

    private

    # @return [Class] The repository class for this model.
    def repository
      Vedeu::Interfaces
    end

    # The default values for a new instance of Interface.
    #
    # @return [Hash]
    def defaults
      {
        border:   {},
        colour:   {},
        cursor:   false,
        geometry: {},
        lines:    [],
        parent:   nil,
      }
    end

  end # Interface

end # Vedeu
