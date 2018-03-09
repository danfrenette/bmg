module Bmg
  module Operator
    #
    # Constants operator.
    #
    # Extends operand's tuples with attributes given at construction.
    # This is a special case of an extension, where the values are
    # statically known.
    #
    class Constants
      include Operator

      def initialize(type, operand, constants)
        @type = type
        @operand = operand
        @constants = constants
      end
      attr_reader :type

    protected

      attr_reader :operand, :constants

    public

      def each
        @operand.each do |tuple|
          yield extend_it(tuple)
        end
      end

      def to_ast
        [ :constants, operand.to_ast, constants.dup ]
      end

    protected ### optimization

      def _restrict(type, predicate)
        # bottom_p makes no reference to constants, top_p possibly
        # does...
        top_p, bottom_p = predicate.and_split(constants.keys)
        if top_p.tautology?
          # push all situation: predicate made no reference to constants
          result = operand
          result = result.restrict(bottom_p)
          result = result.constants(constants)
          result
        elsif (top_p.free_variables - constants.keys).empty?
          # top_p applies to constants only
          if eval = top_p.evaluate(constants)
            result = operand
            result = result.restrict(bottom_p)
            result = result.constants(constants)
            result
          else
            Relation.empty(type)
          end
        elsif bottom_p.tautology?
          # push none situation, no optimization possible since top_p
          # is not a tautology
          super
        else
          # top_p and bottom_p are complex predicates. Let apply each
          # of them
          result = operand
          result = result.restrict(bottom_p)
          result = result.constants(constants)
          result = result.restrict(top_p)
          result
        end
      rescue Predicate::NotSupportedError
        super
      end

    private

      def extend_it(tuple)
        tuple.merge(@constants)
      end

    end # class Constants
  end # module Operator
end # module Bmg
