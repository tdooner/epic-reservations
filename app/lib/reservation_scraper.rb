require 'selenium-webdriver'
require 'webdrivers'

class ReservationScraper
  RETRY_ERRORS = [
    Selenium::WebDriver::Error::NoSuchElementError,
    Selenium::WebDriver::Error::TimeoutError,
    Selenium::WebDriver::Error::UnknownError
  ]

  def initialize(epic_username, epic_password)
    @username = epic_username
    @password = epic_password
    @retries = 3
    @wait = Selenium::WebDriver::Wait.new(timeout: 20)
  end

  def reservations
    if ENV['GOOGLE_CHROME_SHIM']
      Selenium::WebDriver::Chrome.path = ENV['GOOGLE_CHROME_SHIM']
    end
    chrome_opts = Selenium::WebDriver::Chrome::Options.new
    chrome_opts.add_argument('--window-size=1440,1000')
    chrome_opts.add_argument('--disable-dev-shm-usage')

    @driver = Selenium::WebDriver.for :chrome, options: chrome_opts
    puts "Beginning scrape for #{@username}"
    @driver.navigate.to 'https://www.epicpass.com/account/my-account.aspx'
    wait_for(id: 'onetrust-accept-btn-handler')

    puts 'Filling in form'
    @driver.find_element(id: 'onetrust-accept-btn-handler').click # cookie banner
    @driver.find_element(id: 'txtUserName_3').send_keys(@username)
    @driver.find_element(id: 'txtPassword_3').send_keys(@password)
    @driver.find_element(css: '#returningCustomerForm_3 .primaryCTA').click
    wait_for(css: 'h1.title')

    puts 'Logged In'
    @driver.navigate.to 'https://www.epicpass.com/account/my-account.aspx?ma_1=4'
    wait_for(class: 'season_passes__reservations__title--firstPass')
    puts 'Loaded "Reservations" tab'
    @driver.find_element(class: 'season_passes__reservations__title--firstPass').click

    wait_for(css: '.season_passes__reservations__content__list > li')
    reservation_list = @driver.find_elements(css: '.season_passes__reservations__content__list > li')
    puts 'Loaded inner dropdown'

    reservations = reservation_list.map do |res|
      resort = res.find_element(css: 'div > div:nth-child(1)').text
      date = Date.parse(res.find_element(css: 'div > div:nth-child(2)').text)

      { resort: resort, date: date }
    end

    reservations
  rescue *RETRY_ERRORS => ex
    @retries -= 1
    puts "Got exception #{ex}"
    if @retries > 0
      puts 'Retrying in 20 seconds...'
      retry if @retries > 0
    end
  end

  def wait_for(selector)
    @wait.until { @driver.find_element(selector) }
  rescue Selenium::WebDriver::Error::TimeoutError => ex
    puts "Timeout looking for #{selector}: #{ex}"
    puts "Page text: #{@driver.find_element(css: 'body').text}"
  end
end
