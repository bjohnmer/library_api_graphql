module Types
  class AuthorInputType < GraphQL::Schema::InputObject
    graphql_name 'AuthorInputType'
    description 'All attributes for creating an author'

    argument :first_name, String, required: false
    argument :last_name, String, required: false
    argument :yob, Int, required: false
    argument :is_alive, Boolean, required: false
    argument :bio, String, required: false
  end
end

# mutation createAuthor($author:AuthorInputType!){
#   createAuthor(author: $author){
#     id
#     fullName
#   }
# }

# and in the variables

# {
#   "author": {
#     "firstName": "James",
#     "lastName": "Bond",
#     "yob": 1977,
#     "isAlive": false
#   }
# }

