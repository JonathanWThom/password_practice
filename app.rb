require("bundler/setup")
Bundler.require(:default)
require('pry')

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
      ## need a session id
      redirect("/success")
      ## pass the session id to "success" page?
    else
      redirect('/failure')
    end
end

get('/login') do
  erb(:login)
end

get('/success') do
  erb(:success)
end

get('/failure') do
  erb(:failure)
end
