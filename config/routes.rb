Rails.application.routes.draw do
  get 'screener', to: 'screener#index'
  post 'screener/new'
  get 'screener/configure'
  get 'screener/update'
  post 'screener/edit'
  get 'screener/cancel'
  post 'screener/new_filter'
  post 'screener/edit_filter'
  get 'screener/update_filter'
  get 'screener/destroy_filter'
  get 'screener/destroy'
  get 'screener/run'
  get 'screener/queue'
  get 'screener/view'
  get 'screener/last'

  get 'history', to: 'history#index'
  get 'history/update'
  post 'history/open'

  get 'ledger', to: 'ledger#index'
  post 'ledger/deposit'
  post 'ledger/withdraw'
  get 'ledger/update'
  get 'ledger/destroy'

  get 'trade', to: 'trade#index'
  post 'trade/create'
  post 'trade/update_post'
  get 'trade/update'
  post 'trade/close'
  get 'trade/destroy'

  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }

  get 'application', to: 'application#index'
  get 'about', to: 'application#about'
  get 'application/refresh'
  get 'application/ticker'

  root 'application#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
