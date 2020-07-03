module Types
  class BookInputType < GraphQL::Schema::InputObject
    graphql_name 'BookInputType'
    description 'All attributes for creating a book'

    argument :title, String, required: false
    argument :yop, Int, required: false
    argument :category_id, Integer, required: false
    argument :author_id, Integer, required: false
  end
end
