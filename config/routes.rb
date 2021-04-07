Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        resources :find_all, controller: :search, only: :index
        resources :most_items, only: :index
      end

      namespace :items do
        resources :find_one, controller: :search, only: :index
      end

      namespace :revenue do
        resources :merchants, only: [:index, :show]
      end

      resources :merchants, only: [:index, :show] do
        resources :items, controller: :merchant_items, only: :index
      end

      resources :items do
        resources :merchant, controller: :items_merchant, only: :index
      end
    end
  end
end
