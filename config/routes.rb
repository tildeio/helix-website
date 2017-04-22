Rails.application.routes.draw do
  root "static#index"
  get "/:action", controller: "static"
end
