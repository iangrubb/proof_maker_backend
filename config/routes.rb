Rails.application.routes.draw do
  resources :citations
  resources :justifications
  resources :lines
  resources :subproofs
  resources :stages
  resources :proofs
  resources :ptypes
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
