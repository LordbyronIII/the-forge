RebelFoundation::Application.routes.draw do

  # Users
  resources :users do
    resources :transactions, controller: 'users/transactions'
    resources :accounts, controller: 'users/accounts' do
      resources :orders, controller: 'users/accounts/orders' do
        member do
          get :process
          get :transfer
          get :funded
        end
      end
    end
    resources :providers, controller: 'users/providers' do
      get :update
      get :destroy
    end
    resources :posts, controller: 'users/posts' do
      collection do
        get :drafts
      end
      member do
        get :publish
      end
    end
  end
  resources :projects do
    resources :transactions, controller: 'projects/transactions'
    resources :epics, controller: 'projects/epics' do
      resources :stories, controller: 'projects/epics/stories' do
        member do
          get :start
          get :finish
          get :deliver
          get :deny
          put :denied
          get :accept
          get :restart
        end
        resources :tasks, controller: 'projects/epics/stories/tasks'
        resources :comments, controller: 'projects/epics/stories/comments'
        resource :account, controller: 'projects/epics/stories/accounts' do
          resources :transactions, controller: 'projects/epics/stories/accounts/transactions'
        end
      end
    end
    resources :users, controller: 'projects/users'
  end

  # Applies to the logged in user
  match '/dashboard' => 'users#dashboard', as: :dashboard
  match '/profile'   => 'users#edit',      as: :profile

  # Session
  resource  :session
  match '/logout' => 'session#destroy', as: :logout

  # OAuth how you humor me so ...
  match '/auth/:provider/callback' => 'session#create'
  
  root to: 'homepages#index'
end
