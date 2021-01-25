Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resource :epic_logins, only: %i[show update]
  resource :calendar, only: %i[show update]
  resource :reservations, only: %i[show]

  get '/ical_export/:public_share_code' => 'icalendar_exports#show', as: :ical_export

  root to: 'home#homepage'
end
