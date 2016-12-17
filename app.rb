require("bundler/setup")
Bundler.require(:default)
require('pry')

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get('/') do
  erb(:index)
end

post('/sign_in') do
  username = params['username']
  password = params['password']
  password_confirmation = params['password_confirmation']
  @user = User.new(:username => username, :password => password, :password_confirmation => password_confirmation)
  if @user.save()
    erb(:sign_in)
  else
    erb(:errors)
  end
end

get('/sign_in') do
  erb(:sign_in)
end

## puts username and password in url bar!!! no good

get('/user') do
  @user = User.find_by(:username => params['username'])
  if @user
    if @user.authenticate(params['password'])
      erb(:user)
    else
      erb(:errors)
    end
  else
    erb(:errors)
  end
end

post('/user') do
  @user = User.find(params['user_id'])
  @user.authenticate(params['user_password'])
  @user.update({:info => params['info']})
  erb(:user)
end
