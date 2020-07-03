Rails.application.routes.draw do
  devise_for :users, skip: :sessions
  post "/api", to: "graphql#execute"

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/api"
  end
end
