Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resource :user, controller: 'users'

  resource :pin, controller: 'pins'
  resources :pins do
    resources :comments
  end
  resources :comments do
    resources :comments
  end
  get '/checked_saved', to: "pins#checked_saved"
  post '/save_pin', to: "pins#save_pin"
  get '/search_by_category', to: "pins#search_by_category"
  get '/pin_search', to: "pins#search"

  

end
