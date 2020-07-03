module Resolvers::Books
  class Book < Resolvers::Base
    description 'Show a book by ID'

    argument :id, ID, required: true

    type Types::BookType, null: true

    def resolve(id:)
      authenticated_user?(:read, Book)
      ::Book.find(id)
    end
  end
end
