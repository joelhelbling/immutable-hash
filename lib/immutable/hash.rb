require "immutable/hash/version"

module Immutable
  class Hash
    def initialize(base, overlay={}, deleted=[])
      @base = base
      @overlay = overlay
      @deleted = deleted
    end

    def [](key)
      return nil if @deleted.include?(key)
      @overlay[key] || @base[key]
    end

    def prune(*deleted)
      self.class.new(self, {}, deleted.flatten)
    end

    def merge(other_hash)
      self.class.new(self, other_hash)
    end

    def to_hash
      keys.map do |k|
        [k, (@overlay[k] || @base[k])]
      end.to_h
    end
    alias_method :to_h, :to_hash

    def keys
      (@base.keys + @overlay.keys).uniq - @deleted
    end

    def values
      keys.map do |k|
        @overlay[k] || @base[k]
      end
    end

    def undo
      @base
    end

    def []=(key, value)
      raise HashMutationException.new(:[]=)
    end
    def delete(key)
      raise HashMutationException.new(:delete)
    end

  end

  class HashMutationException < StandardError
  end
end
