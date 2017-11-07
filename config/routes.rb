Rails.application.routes.draw do
  resources :reservas
  root to: 'inicio#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
end
