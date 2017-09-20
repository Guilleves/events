Rails.application.routes.draw do
  resources :group_events do
    collection do
      get 'published'
    end
    member do
      patch 'publish'
    end
  end
end
