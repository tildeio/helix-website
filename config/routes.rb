Rails.application.routes.draw do
  root "static#index"

  namespace :demos do
    resource :textify, only: [:create, :show], controller: :textify
  end

  get "/:action", controller: "static"
end
