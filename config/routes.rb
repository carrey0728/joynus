Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get 'login', to: 'sessions#new', as: 'login'
    get 'logout', to: 'sessions#destroy', as: 'logout'
    match '/send_mail', to: 'contact#send_mail', via: 'post'

    root to: 'home#index'

    resources :posts, path: 'blog'
    resources :sessions, only: [:new, :create, :destroy]
    resources :about, only: [:index]
    resources :employers, only: [:index]
    resources :contact, only: [:index]
    resources :unapproved_jobs
    resources :jobs do
      collection do
        put :approve
      end
    end
    resources :users
  end

  get '*path', to: redirect("/#{I18n.default_locale}/%{path}"), constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" }
  get '', to: redirect("/#{I18n.default_locale}")
end
