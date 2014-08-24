module Vedeu
  class Buffer

    attr_reader :back, :front, :interface

    # @param attributes [Hash]
    # @return [Buffer]
    def initialize(attributes = {})
      @attributes = attributes

      @back       = attributes.fetch(:back)
      @front      = attributes.fetch(:front)
      @interface  = attributes.fetch(:interface)
    end

    # @param view [Interface]
    # @return [Buffer]
    def enqueue(view)
      merge({ back: view })
    end

    # @return [Buffer]
    def refresh
      view = if content_available?
        merge({ front: back, back: nil }).front.to_s

      elsif no_content_available?
        interface.clear

      else
        front.to_s

      end

      Terminal.output(view)

      self
    end

    private

    def merge(new_attributes)
      Buffer.new(@attributes.merge(new_attributes))
    end

    def content_available?
      !!(back)
    end

    def no_content_available?
      front.nil?
    end

  end
end