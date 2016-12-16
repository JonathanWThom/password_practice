require("bundler/setup")
Bundler.require(:default)
require('pry')

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get('/') do
  erb(:index)
end

post('/user') do
  username = params['username']
  password = params['password']
  password_confirmation = params['password_confirmation']
  @user = User.create(:username => username, :password => password, :password_confirmation => password_confirmation)
  erb(:success)
end

get('/user') do
  @user = User.find_by(:username => params['username'])
  @user.authenticate(params['password'])
  erb(:success)
end
