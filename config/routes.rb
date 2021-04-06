Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :merchants, path: "merchants(/:per_page/:page)" , only: [:index, :show] do
        resources :items, controller: 'merchant_items', only: :index
        collection do
          get '/find_all(/:name)', to: 'merchants#find_all'
        end
      end
      resources :items, path: "items(/:per_page/:page)" do
        resources :merchant, controller: 'items_merchant', only: :index
        collection do
          get '/find_one(/:name)', to: 'items#find_one'
        end
      end
    end
  end
end
