Rails.application.routes.draw do

  get 'api/coins', as: 'api_coins'
  get 'api/ticker_update', as: 'api_ticker_update'
  get 'ticker', to: 'api#ticker_price', as: 'api_ticker_price'

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
  get '/screeners/:id/show', to: 'screener#view', as: 'screeners_show'
  get '/screeners/:id/last', to: 'screener#last', as: 'screeners_last'

  get '/screeners/trades', to: 'screener#trades', as: 'screeners_trades'
  get '/screeners/funds', to: 'screener#funds', as: 'screeners_funds'

  get 'history', to: 'history#index'
  get 'history/update'
  post 'history/open'

  get 'ledger', to: 'ledger#index'
  post 'ledger/deposit'
  post 'ledger/withdraw'
  post 'ledger/regul'
  get 'ledger/update'
  get 'ledger/destroy'
  get 'ledger/ticker'
  get 'ledger/funds'
  get 'ledger/ledger_entries', as: 'entries'

  get 'trades', to: 'trade#index', as: 'trades'
  post 'trades', to: 'trade#create', as: 'trades_new'
  get '/trades/:id', to: 'trade#show', as: 'trades_show'
  post '/trades/:id', to: 'trade#update', as: 'trades_update'
  post '/trades/:id/close', to: 'trade#close', as: 'trades_close'
  get '/trades/:id/delete', to: 'trade#destroy', as: 'trades_destroy'

  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }

  get 'home', to: 'home#index'
  get 'about', to: 'home#about'
  get 'refresh', to: 'home#refresh'


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
