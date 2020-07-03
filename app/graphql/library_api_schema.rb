class LibraryApiSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # Opt in to the new runtime (default in future graphql-ruby versions)
  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST

  # Add built-in connections for pagination
  use GraphQL::Pagination::Connections

  # Error handlers
  use GraphQL::Execution::Errors

  rescue_from(ActiveRecord::RecordNotFound) do |ex|
    raise GraphQL::ExecutionError.new(ex.message)
  end
end
