# Essentials to building a basic Sinatra app: beyond migrations

# Setting up a flash in Sinatra
# Gemfile
gem 'sinatra-flash'

# app.rb file

require 'sinatra/base'
require 'sinatra/flash'

enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true

# setting a flash message in a route

get '/' do
  flash[:notice] = 'Welcome to the homepage'
end

post '/some_form_submit_route' do
  flash[:alert] = 'There was a problem with that.'
end

# displaying a flash inside of a view
<% if flash[:notice] %>
  <div class="flash notice">
    <%= flash[:notice] %>
</div>
<% end %>



# Helpers
# To define a helper method to use inside of any view:
# inside of your app.rb file

helpers do
  def current_user
    session[:user_id].nil? ? nil : User.find(session[:user_id])
  end
  def display_one
    "1"
  end
end

# using the methods inside of your view
<%= current_user %>
<%= display_one %>



# Using sessions
# Ensure all of the flash code above is setup first
# You can store anything inside of the session hash, for instance, a user id.

# inside app.rb:
post '/sign_in' do
  @user = User.where(params[:user]).first
  if @user && @user.password == params[:password]
    flash[:notice] = "You've successfully signed in."
    session[:user_id] = @user.id
    redirect '/sign_up'
  else
    flash[:alert] = "Sorry, that user doesn't exist. Feel free to sign up."
    redirect '/'
  end
end



# Using forms
# inside of any view
# the form *action* is the Sinatra route (in app.rb) that the form data will be posted to.

<form action="/sign_in" method="POST">
  <label>Email</label>
  <input name="[user]email" type="text"></input>
  <label>Password</label>
  <input name="[user]password" type="password"></input>
  <input type="submit" value="submit"></input>
</form>


# the method attribute on the form is the HTTP verb being used for the request when the form 
# is submitted. So for the above, you'd need a route like this to process the information:
post '/sign_up' do
  #some code here to process any incoming params
  #for instance, params[:user][:email] would be equal to the
  #value of the email input in the form.
end