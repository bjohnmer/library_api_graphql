module Types
  class QueryType < Types::BaseObject
    # Authors
    field :authors, resolver: Resolvers::Authors::Authors
    field :author, resolver: Resolvers::Authors::Author

    # Books
    field :books, resolver: Resolvers::Books::Books
    field :book, resolver: Resolvers::Books::Book

    # Category
    field :categories, resolver: Resolvers::Categories::Categories
    field :category, resolver: Resolvers::Categories::Category

    # Users
    field :users, resolver: Resolvers::Users::Users
    field :user, resolver: Resolvers::Users::User
  end
end
