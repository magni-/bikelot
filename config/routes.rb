Bikelot::Application.routes.draw do
  root to: "static#index"
  resources :locations, only: :create
end
