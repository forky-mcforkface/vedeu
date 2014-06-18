module Vedeu
  module Queue
    extend self

    def dequeue
      store.pop
    end

    def enqueue(result)
      store.unshift(result)
      store
    end

    def enqueued?
      store.size > 0
    end

    def size
      store.size
    end

    def clear
      store.clear
    end
    alias_method :reset, :clear

    def view
      store.inspect
    end

    private

    def store
      @store ||= []
    end
  end
end