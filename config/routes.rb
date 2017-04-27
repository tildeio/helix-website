Rails.application.routes.draw do
  root "static#index"

  namespace :demos do
    resource :textify, only: [:create, :show], controller: :textify
    resource :word_count, only: [:create, :show], controller: :word_count
    resource :inline_css, only: [:create, :show], controller: :inline_css
    resource :line_point, only: [:create, :show], controller: :line_point
  end

  get "/:action", controller: "static"
end
