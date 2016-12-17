require("bundler/setup")
Bundler.require(:default)
require('pry')
enable :sessions

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get('/') do
  erb(:index)
end

post('/signup') do
  user = User.new(:username => params[:username], :password => params[:password], :password_confirmation => params[:password_confirmation])
  if user.save
    redirect "/login"
  else
    redirect "/failure"
  end
end

post('/login') do
  @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      ## must create unique session id
      ## i don't think it's doing that right now

      redirect("/success")
      ## pass the session id to "success" page?
      ## i don't quite understand this
    else
      redirect('/failure')
    end
end

get('/login') do
  erb(:login)
end

get('/success') do
  @user = User.find(session[:user_id])
  erb(:success)
end

get('/failure') do
  erb(:failure)
end
