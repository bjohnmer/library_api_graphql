module Mutations::Books
  class UpdateBook < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :book, Types::BookInputType, required: true

    # Ths is the type this is gonna return
    type Types::BookType

    def resolve(id:, book:)
      authenticated_user?(:update, Book)
      Book.find(id).tap do |b|
        b.update!(book.to_h)
      end
    end
  end
end
