module Resolvers::Categories
  class Category < Resolvers::Base
    description 'Show a category by ID'

    argument :id, ID, required: true

    type Types::CategoryType, null: true

    def resolve(id:)
      authenticated_user?(:read, Category)
      ::Category.find(id)
    end
  end
end
