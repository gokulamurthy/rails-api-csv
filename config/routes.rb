Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  #
  resources :devices, only: [:show], constraints: { id: /[\d+\.]+/ } do
    post :assign, on: :collection
  end
end
