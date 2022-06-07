require_relative 'types/invoice_type'

require_relative 'queries/query'
require_relative 'types/mutation_type.rb'

require 'graphql/errors'

class DummySchema < GraphQL::Schema
  query(Query)
  mutation(MutationType)
  rescue_from(StandardError) do |e|
    GraphQL::ExecutionError.new(e.message)
  end
end
