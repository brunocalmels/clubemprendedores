Rails.application.routes.draw do
  root to: "inicio#index"
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  resources :perfiles, only: %i[show], controller: "users/users"
  get "reservas/esperando_aprobacion", to: "reservas#esperando_aprobacion"
  resources :reservas
  resources :grupos, only: %i[index]
end
