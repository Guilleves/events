Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :group_events do
    collection do
      get 'published'
    end
    member do
      patch 'publish'
    end
  end
end
