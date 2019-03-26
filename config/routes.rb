Rails.application.routes.draw do
  root to: "inicio#index"
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  get "reservas/esperando_aprobacion", to: "reservas#esperando_aprobacion"
  resources :reservas
  # resources :grupos
end
