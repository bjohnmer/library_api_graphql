module Types
  class AuthorType < Types::BaseObject
    description 'AuthorType'

    # Relations
    field :books, [Types::BookType], null: true

    # Fields
    field :id, ID, null: false
    field :yob, Int, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :is_alive, Boolean, null: false
    field :full_name, String, null: true
    field :bio, String, null: true
  end
end
