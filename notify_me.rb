require 'sinatra'
require 'sinatra/sequel'

set :product_name, 'Acme Widget'
set :database, ENV['DATABASE_URL'] || 'sqlite://subscriptions.db'

migration "create subscriptions" do
  database.create_table :subscriptions do
    primary_key :id
    string      :email, :null => false
    timestamp   :created_at, :null => false
  end
end

class Subscription < Sequel::Model
end

get '/' do
  haml :index
end

post '/subscribe' do
  if params[:email].empty?
    halt 'Email is required to subscribe!'
  end
  @email = params[:email]
  Subscription.insert(:email => @email, :created_at => DateTime.now) unless Subscription.find(:email => @email)
  haml :success
end

get '/reset.css' do
  sass :reset
end

get '/stylesheet.css' do
  sass :notify_me
end