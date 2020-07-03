module Types
  class CategoryType < Types::BaseObject
    description 'Categories'

    # Relations
    field :books, [Types::BookType], null: false

    # Fields
    field :id, ID, null: false
    field :name, String, null: false
  end
end
