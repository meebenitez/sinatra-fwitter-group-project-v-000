require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    if logged_in?
      redirect '/tweets'
    else
      erb :index
    end
  end
  #

  get '/signup' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'users/create_user'
    end

  end

  post '/signup' do
     if params[:username] == "" || params[:password] == "" || params[:email] == ""
       redirect '/signup'
      else
        @user = User.new(username: params[:username], password: params[:password], email: params[:email])
        @user.save
        session[:user_id] = @user.id
        redirect '/tweets'
      end
  end

  get '/login' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect '/tweets'
      else
        redirect '/login'
      end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :'tweets/create_tweet'
    else
      redirect '/login'
    end
  end
  #

  get '/tweets' do
    if logged_in?
      @user = current_user
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    @user = current_user
    if params[:content] != ""
      @tweet = Tweet.create(content: params[:content])
      current_user.tweets << @tweet
      current_user.save
    else
      redirect '/tweets/new'
    end
    redirect '/tweets'
  end



  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in?
      erb :'tweets/edit_tweet'
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in? && @tweet.user_id == current_user.id
      if params[:content] == ""
        redirect "/tweets/#{@tweet.id}/edit"
      else
        @tweet.update(content: params[:content])
        redirect "/tweets/#{@tweet.id}"
      end
    elsif logged_in? && @tweet.user_id != current_user.id
      erb :'tweets/show_tweet'
    else
      redirect '/login'
    end
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in? && @tweet.user_id == current_user.id
      @tweet.delete
      redirect '/tweets'
    elsif logged_in? && @tweet.user_id != current_user.id
      redirect "/tweets/#{@tweet.id}"
    else
      redirect '/login'
    end

  end


  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    @tweets = @user.tweets
    erb :'/users/show'
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
