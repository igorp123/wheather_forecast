class Forecast
  CLOUDINESS = %w(ясно малооблачно облачно пасмурно).freeze
  TIME_OF_THE_DAY = %w(ночь утро день вечер).freeze

  def initialize(forecast_date:, min_temp:, max_temp:, max_wind:, clouds:, tod:)
    @forecast_date = forecast_date
    @min_temp = min_temp
    @max_temp = max_temp
    @max_wind = max_wind
    @clouds = clouds
    @tod = tod
  end

  def self.read_from_internet(city_index)
    uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/#{city_index}.xml")

    response = Net::HTTP.get_response(uri)

    doc = REXML::Document.new(response.body)

    forecast = doc.root.elements['REPORT/TOWN']

    forecasts = []

    city_name =URI.unescape(forecast.attributes['sname'])

    forecast.elements.each do |forecast|
      forecasts << self.new(from_xml(forecast))
    end

    {city_name: city_name, forecasts: forecasts}
  end

  def self.from_xml(forecast)
    forecast_date =
      Date.new *[
        forecast.attributes['year'],
        forecast.attributes['month'],
        forecast.attributes['day']
      ].map(&:to_i)

    max_temp = forecast.elements['TEMPERATURE'].attributes['max'].to_i
    min_temp = forecast.elements['TEMPERATURE'].attributes['min'].to_i

    max_wind = forecast.elements['WIND'].attributes['max']

    cloud_index = forecast.elements['PHENOMENA'].attributes['cloudiness'].to_i
    clouds = CLOUDINESS[cloud_index]

    tod_index = forecast.attributes['tod'].to_i
    tod = TIME_OF_THE_DAY[tod_index]

    {
      forecast_date: forecast_date,
      min_temp: min_temp,
      max_temp: max_temp,
      max_wind: max_wind,
      clouds: clouds,
      tod: tod
    }
  end

  def is_today?
    @forecast_date == Date.today
  end

  def result_date
    return "Сегодня" if is_today?

    @forecast_date.strftime('%d.%m.%Y')
  end

  def temperature_range
    range = ""
    range << "+" if @min_temp > 0
    range << "#{@min_temp}.."
    range << "+" if @max_temp > 0
    range << @max_temp.to_s
  end

  def to_s
    "#{result_date}, #{@tod}\n\n" \
    "#{temperature_range}, ветер #{@max_wind} м/с, #{@clouds}\n"
  end
end
