require 'forecast'
require 'net/http'
require 'uri'
require 'rexml/document'
require 'date'

describe Forecast do
  describe 'to_s' do
    let(:forecast) do
      Forecast.new(
        forecast_date: Date.parse('31.10.2018'),
        min_temp: -5,
        max_temp: 5,
        max_wind: 10,
        clouds: 'пасмурно',
        tod: 'утро'
      )
    end

    it 'returns temperature_range' do
      expect(forecast.to_s).to include('-5..+5')
    end

    it 'returns time of the day' do
      expect(forecast.to_s).to include('утро')
    end

    it 'returns date' do
      expect(forecast.to_s).to include('31.10.2018')
    end

    it 'cloudness' do
      expect(forecast.to_s).to include('пасмурно')
    end
  end

  describe 'read_from_internet' do
    it 'returns city name' do
      forecasts = Forecast.read_from_internet
      city_name = forecasts[:city_name]
      expect(city_name).to eq 'Москва'
    end

    it 'returns number of forecasts' do
      forecasts = Forecast.read_from_internet
      expect(forecasts[:forecasts].size).to eq 4
    end
  end
end

