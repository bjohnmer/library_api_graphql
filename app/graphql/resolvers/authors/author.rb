module Resolvers::Authors
  class Author < Resolvers::Base
    description 'Show an author by ID'

    argument :id, ID, required: true

    type Types::AuthorType, null: true

    def resolve(id:)
      authenticated_user?(:read, Author)
      ::Author.find(id)
    end
  end
end
