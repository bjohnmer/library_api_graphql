module Types
  class BookType < Types::BaseObject
    description 'BookType'

    # Relations
    field :authors, [Types::AuthorType], null: false
    field :category, Types::CategoryType, null: false

    # Fields
    field :id, ID, null: false
    field :yop, Integer, null: false
    field :title, String, null: false
  end
end
