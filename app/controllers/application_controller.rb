require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    erb :index
  end
  #
   get '/tweets/new' do
     erb :'tweets/create_tweet'
   end
  #
  post '/tweets' do
    erb :'tweets/tweets'
  end

  get '/tweets/:id' do
    erb :'tweets/show_tweet'
  end

  get '/tweets/:id/edit' do
    erb :'tweets/edit_tweet'
  end

  post '/tweets/:id' do

  end

  post '/tweets/:id/delete' do

  end

  get '/signup' do
    if !logged_in
      redirect '/tweets'
    else
      erb :'users/create_user'
    end

  end

  post '/signup' do
    #if !logged_in
     if params[:username] == "" || params[:password] == "" || params[:email] == ""
       redirect '/signup'
      else
        @user = User.new(username: params[:username], password: params[:password], email: params[:email])
        @user.save
        session[:user_id] = @user.id
        redirect '/tweets'
      end
    #else
    #  redirect '/'
    #end
  end

  get '/login' do
    erb :'users/login'
  end

  post '/login' do

  end

  get 'logout' do
    session.clear
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end
#
    def current_user
      User.find(session[:user_id])
    end
  end

end
