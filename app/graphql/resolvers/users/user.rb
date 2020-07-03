require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers::Users
  class User < Resolvers::Base
    # include SearchObject for GraphQL
    include SearchObject.module(:graphql)

    description 'Show the user'

    # Starting point for searching
    scope do
      authenticated_user?(:read, User)
      ::User.all
    end

    type Types::UserType, null: true

    # when object "filter" is passed "apply_filter" will be called
    option :id, type: String, with: :apply_filter

    # apply_filter calls recursively through all "OR" and "AND" arguments
    def apply_filter(scope, value)
      _, id = GraphQL::Schema::UniqueWithinType.decode(value)
      scope.find(id)
    end
  end
end
