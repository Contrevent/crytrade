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

  get 'home', to: 'home#index'
  get 'about', to: 'home#about'
  get 'refresh', to: 'home#refresh'
  get 'ticker', to: 'home#ticker'

  get 'settings', to: 'settings#settings'
  post 'post_settings', to: 'settings#post_settings'
  get 'settings/dashboard'
  post 'settings/new_tile'
  post 'settings/update_tile'
  get 'settings/destroy_tile'
  get 'settings/move_tile'

  get 'dash', to: 'dashboard#index'

  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
