require("bundler/setup")
Bundler.require(:default)
require('pry')
enable :sessions

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

##make pages nice, use as a "default" password app

get('/') do
  erb(:index)
end

get('/signup') do
  redirect('/')
end

post('/signup') do
  user = User.new(:username => params[:username], :password => params[:password], :password_confirmation => params[:password_confirmation])
  if user.save
    redirect "/login"
  else
    redirect "/failure"
  end
end
## need to set uniqueness on username

post('/login') do
  @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect("/success")
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
## figure out session timeout after inactivity

get('/logout') do
  session.clear
  redirect('/')
end

get('/failure') do
  erb(:failure)
end
