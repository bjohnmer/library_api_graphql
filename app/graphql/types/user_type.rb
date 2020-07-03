module Types
  class UserType < Types::BaseObject
    field :id, String, null: true
    field :last_name, String, null: true
    field :first_name, String, null: true
    field :email, String, null: true

    field :authentication_token, String, null: true
    def authentication_token
      return nil if object.gql_id != context[:current_user]&.gql_id
      object.authentication_token
    end

    def id
      GraphQL::Schema::UniqueWithinType.encode(object.class.name, object.id)
    end
  end
end
