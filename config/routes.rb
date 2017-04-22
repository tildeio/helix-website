Rails.application.routes.draw do
  resources :statics

  root "statics#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
