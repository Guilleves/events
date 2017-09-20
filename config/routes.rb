Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :group_events do
    member do
      get 'published'
      post 'publish'
    end
  end
end
