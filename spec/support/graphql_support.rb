# frozen_string_literal: true

module GqlSupport
  def self.gql_query(query:, variables: {}, context: {})
    query = GraphQL::Query.new(
      LibraryApiSchema,
      query,
      variables: variables.deep_stringify_keys,
      context: context
    )

    query.result
  end
end
