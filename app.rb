#encoding: utf-8
require "rubygems"
require "sinatra"
require "sinatra/reloader"
require "sinatra/activerecord"

set :database, { adapter: "sqlite3", database: "barbershop.db" }

class Client < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }
  validates :phone, presence: true
  validates :datestamp, presence: true
  # validates :barber, presence: true
  validates :color, presence: true
end

class Barber < ActiveRecord::Base
end

before do
  @barbers = Barber.all
end

get "/" do
  erb :index
end

get "/visit" do
  @client = Client.new
  erb :visit
end

post "/visit" do

  # Запись в базу данных
  @client = Client.new params[:client]

  if @client.save
    erb "<h2>Спасибо Вы записались</h2>"
  else
    @error = @client.errors.full_messages.first
    erb :visit
  end
end

get "/barber/:id" do
  @barber = Barber.find(params[:id])
  erb :barber
end