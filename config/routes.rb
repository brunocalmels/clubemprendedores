Rails.application.routes.draw do
  resources :reservas, only: %i[show create new update destroy edit]
  root to: 'inicio#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
end
