Rails.application.routes.draw do
  devise_for :admin_users,
             ActiveAdmin::Devise.config.deep_merge({ controllers: { registrations: 'active_admin/admin_users/registrations' } })

  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'admin/dashboard#index'
end
