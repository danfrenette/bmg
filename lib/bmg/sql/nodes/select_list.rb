module Bmg
  module Sql
    module SelectList
      include Expr

      def desaliaser
        ->(a){
          item = sexpr_body.find{|item| item.as_name.to_s == a.to_s }
          item && item.left
        }
      end

      def is_table_dee?
        Builder::IS_TABLE_DEE == self
      end

      def knows?(as_name)
        find_child{|child| child.as_name == as_name }
      end

      def to_attr_list
        sexpr_body.map{|a| a.as_name.to_sym }
      end

      def to_sql(buffer, dialect)
        sexpr_body.each_with_index do |item,index|
          buffer << COMMA << SPACE unless index == 0
          item.to_sql(buffer, dialect)
        end
        buffer
      end

    end # module SelectList
  end # module Sql
end # module Bmg