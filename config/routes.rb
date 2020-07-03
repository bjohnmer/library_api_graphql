Rails.application.routes.draw do
  devise_for :users, skip: :sessions
  post "/api", to: "graphql#execute"
end
