module Mutations::Books
  class DeleteBook < Mutations::BaseMutation
    argument :id, ID, required: true

    # Ths is the type this is gonna return
    type Boolean

    def resolve(id:)
      authenticated_user?(:delete, Book)
      Book.find(id).destroy
    end
  end
end
