Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :merchants, path: "merchants(/:per_page/:page)" , only: [:index, :show] do
        resources :items, controller: 'merchant_items', only: :index
      end
      # get '/merchants(/:per_page/:page)', to: 'merchants#index', as: 'merchants'
      # get '/merchants/:id', to: 'merchants#show', as: 'merchant'
      # get '/merchants/:id/items', to: 'merchant_items#index', as: 'merchant_items'
    end
  end
end
