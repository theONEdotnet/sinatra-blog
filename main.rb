require "sinatra"
# noinspection RubyResolve
require "sinatra/activerecord"
require "sinatra/flash"
require "./models"

set :database, "sqlite3:test.sqlite3"
enable :sessions

get "/" do
  @users = User.all
  @posts = Post.all
  @user = User.find(session[:user_id])

  session[:visited] = "I'm here"

  p session[:visited]

  erb :index
end


get "/sign_up" do
  erb :sign_up
end

post "/login" do
  @user = User.where(username: params[:username]).first   
  if @user.password == params[:password]     
    redirect "/"
  else     
    redirect "/login-failed"
  end 
end


get "/logout" do
  session.clear
  flash[:notice] = "You've successfully logged out!"

  redirect "../"
end



get "/users" do
  erb :users
end


get "/profile" do
  erb :profile
end


get "/feed" do
  erb :feed
end


get "/post" do
  erb :post
end


post "/posts" do
  post = Post.new

  post.title = params["title"]
  post.body = params["body"]

  post.save

  redirect "/"
end


get "/posts/:id" do
  @post = Post.find(params[:id])

  erb :post_show
end


get "/posts/edit/:id" do
  @post = Post.find(params[:id])

  erb :post_edit
end


post "/posts/edit/:id" do
  @post = Post.find(params[:id])

  @post.title = params[:title]
  @post.body = params[:body]

  @post.save

  redirect "/posts/#{@post.id}"
end


get "/posts/delete/:id" do
  post = Post.find(params[:id])
  post.destroy

  redirect "/"
end


post "/sessions/new" do
  user = User.where(email: params[:email]).first

  if user
    session[:user_id] = user.id
    flash[:notice] = "You've successfully signed in!"
  end

  redirect "/"
end



def current_user
  @current_user = User.find(session[:user_id])
end
