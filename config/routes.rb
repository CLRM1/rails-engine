Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/api/v1/items/find', to: 'api/v1/items#find'
  get '/api/v1/items/find_all', to: 'api/v1/items#find_all'

  get '/api/v1/merchants/find', to: 'api/v1/merchants#find'
  get '/api/v1/merchants/find_all', to: 'api/v1/merchants#find_all'

  namespace :api do
    namespace :v1 do
      resources :merchants do
        resources :items, action: :index_merchants
      end
      resources :items do
        resources :merchant
      end
    end
  end
end
