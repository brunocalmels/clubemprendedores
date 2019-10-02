Rails.application.routes.draw do
  root to: "inicio#index"
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  authenticated :user do
    resources :perfiles, only: %i[show], controller: "users/users"
    get "reservas/esperando_aprobacion", to: "reservas#esperando_aprobacion"
    get "reservas/to_calendar", to: "reservas#to_calendar"
    resources :reservas
    resources :grupos, only: %i[index edit update]
    put "grupos/:id/add_user", to: "grupos#add_user"
    get "docs", to: "inicio#docs"
  end
end
