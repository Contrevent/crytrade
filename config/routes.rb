Rails.application.routes.draw do
  get 'trade/list'

  post 'trade/create'
  post 'trade/update_post'

  get 'trade/update'

  post 'trade/close'
  get 'trade/destroy'

  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }

  get 'application/index'

  root 'application#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
