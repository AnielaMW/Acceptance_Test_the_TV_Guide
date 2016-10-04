require 'sinatra'
require 'sinatra/flash'
require 'csv'
require 'pry'
require_relative "app/models/television_show"

enable :sessions

set :views, File.join(File.dirname(__FILE__), "app/views")

get '/television_shows' do
  @shows = TelevisionShow.all
  erb :index
end

get '/television_shows/new' do
  erb :new
end

post '/television-shows/new' do
  @new_show = TelevisionShow.new(
    params["title"],
    params["network"],
    params["starting_year"],
    params["synopsis"],
    params["genre"]
  )

  if @new_show.save
    redirect '/television_shows'
  else
    flash.now[:error] = @new_show.errors
    erb :new
  end
end
