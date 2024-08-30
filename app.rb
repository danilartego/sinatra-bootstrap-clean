#encoding: utf-8
require "rubygems"
require "sinatra"
require "sinatra/reloader"
require "sinatra/activerecord"

set :database, { adapter: "sqlite3", database: "barbershop.db" }

class Client < ActiveRecord::Base
  validates :name, presence: true
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
  erb :visit
end

post "/visit" do

  # Хеш с параметрами
  hh = {
    username: "Введите имя",
    phone: "Введите телефон",
    datestamp: "Введите дату и время",
  }

  # Обработка ошибок, проверка на пустое значение
  @error = hh.select { |key, _| params[key] == "" }.values.join(", ")

  # Возварт страницы если чтото не заполнено
  return erb :visit if @error != ""

  # Запись в базу данных
  client = Client.new params[:client]

  if client.save
    erb "<h2>Спасибо Вы записались</h2>"
  else
    @error = client.errors.full_messages.first
    erb :visit
  end
end
