module Types
  class MutationType < Types::BaseObject
    # Authors
    field :create_author, mutation: Mutations::Authors::CreateAuthor
    field :update_author, mutation: Mutations::Authors::UpdateAuthor
    field :delete_author, mutation: Mutations::Authors::DeleteAuthor

    # Books
    field :create_book, mutation: Mutations::Books::CreateBook
    field :update_book, mutation: Mutations::Books::UpdateBook
    field :delete_book, mutation: Mutations::Books::DeleteBook

    # Sessions
    field :sign_in, resolver: Mutations::Users::SignIn
    field :sign_out, resolver: Mutations::Users::SignOut
  end
end
