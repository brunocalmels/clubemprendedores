Rails.application.routes.draw do
  mount Pwa::Engine, at: ""

  root to: "inicio#index"
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  get "reservas/esperando_aprobacion", to: "reservas#esperando_aprobacion"
  resources :reservas
end
