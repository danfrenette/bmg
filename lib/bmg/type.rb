module Bmg
  class Type

    def initialize(predicate = Predicate.tautology)
      @predicate = predicate
      raise ArgumentError if @predicate.nil?
    end

    ANY = Type.new

  public ## predicate

    attr_accessor :predicate
    protected :predicate=

  public ## attrlist

    attr_accessor :attrlist
    protected :attrlist=

    def with_attrlist(attrlist)
      dup.tap{|x|
        x.attrlist = attrlist
      }
    end

    def knows_attrlist?
      !self.attrlist.nil?
    end

    def to_attrlist
      self.attrlist
    end

  public ## keys

    attr_accessor :keys
    alias :_keys :keys
    protected :_keys, :keys=

    def knows_keys?
      !!@keys
    end

    def keys
      return @keys.to_a if @keys
      return [attrlist] if knows_attrlist?
      nil
    end

    def with_keys(keys)
      dup.tap{|x|
        x.keys = Keys.new(keys)
      }
    end

  public ## typing

    def [](attribute)
      ANY
    end

  public ### algebra

    def allbut(butlist)
      dup.tap{|x|
        x.attrlist  = self.attrlist - butlist if knows_attrlist?
        x.predicate = Predicate.tautology
        x.keys      = self._keys.allbut(self, x, butlist) if knows_keys?
      }
    end

    def autowrap(options)
      ANY
    end

    def autosummarize(by, summarization)
      ANY
    end

    def constants(cs)
      dup.tap{|x|
        x.attrlist  = self.attrlist + cs.keys if knows_attrlist?
        x.predicate = self.predicate & Predicate.eq(cs)
        ### keys stay the same
      }
    end

    def extend(extension)
      dup.tap{|x|
        x.attrlist  = self.attrlist + extension.keys if knows_attrlist?
        x.predicate = Predicate.tautology
        ### keys stay the same (?)
      }
    end

    def group(attrs, as)
      dup.tap{|x|
        x.attrlist  = self.attrlist - attrs + [as] if knows_attrlist?
        x.predicate = Predicate.tautology
        x.keys      = self._keys.group(self, x, attrs, as) if knows_keys?
      }
    end

    def image(right, as, on, options)
      dup.tap{|x|
        x.attrlist  = self.attrlist + [as] if knows_attrlist?
        x.predicate = Predicate.tautology
        x.keys      = self._keys
      }
    end

    def matching(right, on)
      self
    end

    def page(ordering, page_size, options)
      self
    end

    def project(attrlist)
      dup.tap{|x|
        x.attrlist  = attrlist
        x.predicate = Predicate.tautology
        x.keys      = self._keys.project(self, x, attrlist) if knows_keys?
      }
    end

    def rename(renaming)
      dup.tap{|x|
        x.attrlist  = self.attrlist.map{|a| renaming[a] || a } if knows_attrlist?
        x.predicate = self.predicate.rename(renaming)
        x.keys      = self._keys.rename(self, x, renaming) if knows_keys?
      }
    end

    def restrict(predicate)
      dup.tap{|x|
        ### attrlist stays the same
        x.predicate = self.predicate & predicate
        x.keys      = self._keys if knows_keys?
      }
    end

    def union(other)
      dup.tap{|x|
        ### attrlist stays the same
        x.predicate = self.predicate | predicate
        x.keys      = self._keys.union(self, x, other) if knows_keys?
      }
    end

  end # class Type
end # module Bmg
