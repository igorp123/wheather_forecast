require 'net/http'
require 'uri'
require 'rexml/document'
require 'date'

require_relative 'lib/forecast'

cities = {
  'Москва' => 37,
  'Пермь' => 59,
  'Санкт-Петербург' => 69,
  'Новосибирск' => 99,
  'Орел' => 115,
  'Чита' => 121,
  'Братск' => 141,
  'Краснодар' => 199
}

cities_names = cities.keys

user_input = -1

until user_input.between?(1, cities_names.size)
  puts 'Погоду для какого города Вы хотите узнать?'

  cities_names.each_with_index { |city, index| puts "#{index + 1}. #{city}" }

  user_input = STDIN.gets.to_i
end

city_id = cities[cities_names[user_input - 1]]

forecasts = Forecast.read_from_internet(city_id)

city_name = forecasts[:city_name]

puts city_name
puts

forecasts[:forecasts].each do |forecast|
  puts forecast
  puts
end
