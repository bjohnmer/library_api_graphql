module Resolvers::Categories
  class Categories < Resolvers::Base
    description 'Show all categories'

    type [Types::CategoryType], null: true

    def resolve
      authenticated_user?(:read, Category)
      ::Category.all
    end
  end
end
