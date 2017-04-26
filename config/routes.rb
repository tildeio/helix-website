Rails.application.routes.draw do
  root "static#index"

  namespace :demos do
    resource :textify, only: [:create, :show], controller: :textify
    resource :word_count, only: [:create, :show], controller: :word_count
    resource :inline_css, only: [:create, :show], controller: :inline_css
  end

  get "/:action", controller: "static"
end
