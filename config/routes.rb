Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  resources :posts, :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root"posts#index"
end
