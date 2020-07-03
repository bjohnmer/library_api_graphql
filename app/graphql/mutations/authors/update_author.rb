module Mutations::Authors
  class UpdateAuthor < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :author, Types::AuthorInputType, required: true

    # Ths is the type this is gonna return
    type Types::AuthorType

    def resolve(id:, author:)
      authenticated_user?(:update, Author)
      Author.find(id).tap do |a|
        a.update!(author.to_h)
      end
    end

    # def self.accessible?(context)
    #   context[:current_user]&.is_superadmin?
    # end
  end
end
