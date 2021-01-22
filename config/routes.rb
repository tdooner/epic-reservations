Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get '/ical_export/:public_share_code' => 'icalendar_exports#show'

  root to: 'home#homepage'
end
