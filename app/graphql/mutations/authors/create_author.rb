module Mutations::Authors
  class CreateAuthor < Mutations::BaseMutation
    argument :author, Types::AuthorInputType, required: true

    # Ths is the type this is gonna return
    type Types::AuthorType

    def resolve(author:)
      authenticated_user?(:create, Author)
      Author.create!(author.to_h)
    end
  end
end
