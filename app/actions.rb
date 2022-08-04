get '/finstagram_posts/:id' do
    @finstagram_post = FinstagramPost.find(params[:id])
    erb(:"finstagram_posts/show")
end

helpers do
    def current_user
        User.find_by(id: session[:user_id])
    end
end

# Controller (list of actions/routes)

# Index page (read)
get '/' do
    @finstagram_posts = FinstagramPost.order(created_at: :desc)
    erb(:index)
end

# Signup page (read)
get '/signup' do
    @user = User.new
    erb(:signup)
end

# Signup a User (create)
post '/signup' do
    
    email       = params[:email]
    avatar_url  = params[:avatar_url]
    username    = params[:username]
    password    = params[:password]

    @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })
    
    if @user.save 
        redirect to('/login')   
    else
        erb(:signup)
    end
end

# Login page
get '/login' do
    erb(:login)
end

# Login a User
post '/login' do
    username = params[:username]
    password = params[:password]

    user = User.find_by(username: username)

    if user && user.password == password
        session[:user_id] = user.id
        redirect to('/')
    else 
       @error_message = "Login failed"
       erb(:login)
    end

end

# Logout a User
get '/logout' do
    session[:user_id] = nil
    redirect to('/')
end

#FinstagramPost form
get '/finstagram_posts/new' do
    @finstagram_post = FinstagramPost.new
    erb(:"finstagram_posts/new")
end

# Create a FinstagramPost
post '/finstagram_posts' do
    photo_url = params[:photo_url]
  
    @finstagram_post = FinstagramPost.new({ photo_url: photo_url, user_id: current_user.id })
  
    if @finstagram_post.save
      redirect(to('/'))
    else
      erb(:"finstagram_posts/new")
end


end




