module Scrapers
  class WeatherScraper < BaseScraper
    RESORT_WEATHER_URLS = {
      'Heavenly' => 'https://www.skiheavenly.com/the-mountain/mountain-conditions/snow-and-weather-report.aspx',
      'Northstar' => 'https://www.northstarcalifornia.com/the-mountain/mountain-conditions/snow-and-weather-report.aspx',
      'Kirkwood' => 'https://www.kirkwood.com/the-mountain/mountain-conditions/snow-and-weather-report.aspx',
    }

    def initialize(resort_key)
      @resort_key = resort_key
      @wait = Selenium::WebDriver::Wait.new(timeout: 20)
      @today = Date.today
    end

    def fetch_weather_forecast
      weather_url = RESORT_WEATHER_URLS[@resort_key]
      unless weather_url
        puts 'Cannot scrape resort: #{@resort_key}: Needs added to RESORT_WEATHER_URLS'
        return
      end

      @driver = initialize_webdriver

      puts "Beginning scrape of #{@resort_key}"
      @driver.navigate.to weather_url
      wait_for(id: 'onetrust-accept-btn-handler')
      @driver.find_element(id: 'onetrust-accept-btn-handler').click # cookie banner

      wait_for(css: 'h3.forecast__ahead__title')

      puts "Parsing forecast..."
      weather_forecast_list = @driver.find_elements(css: '.forecast__accordion__item__container')
      weather_forecast_list.map do |forecast_row|
        forecast_row.click

        month, day = forecast_row.text.split("\n")
        year = @today.year
        year += 1 if @today.month == 12 && month == 'JAN'
        weather_date = Date.parse("#{month} #{day}, #{year}")

        temp_hi = forecast_row.find_element(class: 'forecast__accordion__body__hi__temp').text
        temp_lo = forecast_row.find_element(class: 'forecast__accordion__body__lo__temp').text

        sn_day = forecast_row.find_elements(class: 'forecast__accordion__body__daytime__snow').first&.text || 0
        sn_overnight = forecast_row.find_elements(class: 'forecast__accordion__body__overnight__snow').first&.text || 0
        remarks = forecast_row.find_elements(class: 'forecast__accordion__body__description').first&.text

        WeatherForecast.find_or_initialize_by(
          date: weather_date,
          resort_name: @resort_key
        ).update(
          temperature_high: temp_hi,
          temperature_low: temp_lo,
          snow_day: sn_day,
          snow_overnight: sn_overnight,
          remarks: remarks,
        )
      end
    end

    def wait_for(selector)
      @wait.until { @driver.find_element(selector) }
    rescue Selenium::WebDriver::Error::TimeoutError => ex
      puts "Timeout looking for #{selector}: #{ex}"
      puts "Page text: #{@driver.find_element(css: 'body').text}"
    end
  end
end
