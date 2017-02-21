# app.rb

# when a form is submitted to the 'sign-in' url with a POST request
post '/sign-in' do
  # set @user equal to a user that has the username requested
  # use .first after .where because .where always returns an array,
  # this way you're working with a singular user object
  @user = User.where(username: params[:username]).first
  # first check if a user is returned at all (nil is a 'falsey' value)
  # then check if the user's password is correct
  if @user && @user.password == params[:password]
    # log in the user by setting the session[:user_id] to their ID
    session[:user_id] = @user.id
    # set a flash notice letting the user know that they've logged in successfully
    flash[:notice] = "You've been signed in successfully."
  else
    # if the user doesn't exist or their password is wrong, send them a 
    # flash alert saying so
    flash[:alert] = "There was a problem signing you in."
  end
  # redirect them to the home page
  redirect "/"
end



# abbreviated layout.erb

<body>
  <% if flash[:notice] %>
    <div class="flash notice">
      <%=flash[:notice] %>
    </div>
  <% end %>
  <% if flash[:alert] %>
    <div class="flash alert">
      <%=flash[:alert] %>
    </div>
  <% end %>
  <%=yield %>
</body>
