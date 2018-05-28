module Bmg
  module Sql
    describe Relation do

      let(:suppliers) {
        Bmg.sql(:suppliers)
      }

      context 'a base one' do
        it 'compiles to expected SQL' do
          r = suppliers
          expect(r.to_sql).to eql(%Q{SELECT "t1".* FROM "suppliers" AS "t1"})
        end
      end

      context '.rename' do
        it 'compiles to expected SQL' do
          r = suppliers.project([:id, :name]).rename(:id => :identifier)
          expect(r.to_sql).to eql(%Q{SELECT DISTINCT "t1"."id" AS "identifier", "t1"."name" FROM "suppliers" AS "t1"})
        end

        it 'supports being applied twice' do
          r = suppliers.project([:id, :name]).rename(:id => :identifier).rename(:identifier => :ident)
          expect(r.to_sql).to eql(%Q{SELECT DISTINCT "t1"."id" AS "ident", "t1"."name" FROM "suppliers" AS "t1"})
        end
      end

      context '.restrict' do
        it 'compiles to expected SQL on *' do
          r = suppliers.restrict(:id => "S1")
          expect(r.to_sql).to eql(%Q{SELECT "t1".* FROM "suppliers" AS "t1" WHERE "t1"."id" = 'S1'})
        end

        it 'compiles to expected SQL on attrlits' do
          r = suppliers.project([:id, :name]).restrict(:id => "S1")
          expect(r.to_sql).to eql(%Q{SELECT DISTINCT "t1"."id", "t1"."name" FROM "suppliers" AS "t1" WHERE "t1"."id" = 'S1'})
        end

        context '.restrict' do
          it 'compiles to expected SQL' do
            r = suppliers.project([:id, :name]).restrict(:id => "S1").restrict(:name => "Smith")
            expect(r.to_sql).to eql(%Q{SELECT DISTINCT "t1"."id", "t1"."name" FROM "suppliers" AS "t1" WHERE "t1"."id" = 'S1' AND "t1"."name" = 'Smith'})
          end
        end
      end

      context '.project' do
        it 'compiles to expected SQL' do
          r = suppliers.project([:id, :name])
          expect(r.to_sql).to eql(%Q{SELECT DISTINCT "t1"."id", "t1"."name" FROM "suppliers" AS "t1"})
        end

        it 'it supports being applied twice' do
          r = suppliers.project([:id, :name]).project([:id])
          expect(r.to_sql).to eql(%Q{SELECT DISTINCT "t1"."id" FROM "suppliers" AS "t1"})
        end
      end

    end
  end # module Sql
end # module Bmg