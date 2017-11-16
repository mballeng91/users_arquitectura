Rails.application.routes.draw do
  resources :items
  resources :users
    get 'authorize' => 'users#testSession'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	post 'authenticate', to: 'authentication#authenticate'
	#resources :users
	get 'search', to: 'users#search'

    get 'logout', to: 'users#logout'


end
