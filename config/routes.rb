Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :merchants, path: "merchants(/:per_page/:page)" , only: [:index, :show] do
        resources :items, controller: 'merchant_items', only: :index
      end
      resources :items, path: "items(/:per_page/:page)"
    end
  end
end
