module Mutations::Authors
  class DeleteAuthor < Mutations::BaseMutation
    argument :id, ID, required: true

    # Ths is the type this is gonna return
    type Boolean

    def resolve(id:)
      authenticated_user?(:delete, Author)
      Author.find(id).destroy
    end
  end
end
