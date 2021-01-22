require 'selenium-webdriver'
require 'webdrivers'

class ReservationScraper
  def initialize(epic_username, epic_password)
    @username = epic_username
    @password = epic_password
    @retries = 3
  end

  def reservations
    if ENV['GOOGLE_CHROME_SHIM']
      Selenium::WebDriver::Chrome.path = ENV['GOOGLE_CHROME_SHIM']
    end
    chrome_opts = Selenium::WebDriver::Chrome::Options.new
    chrome_opts.add_argument('--window-size=1440,1000')
    chrome_opts.add_argument('--disable-dev-shm-usage')
    wait = Selenium::WebDriver::Wait.new(timeout: 10)

    driver = Selenium::WebDriver.for :chrome, options: chrome_opts
    puts "Beginning scrape for #{@username}"
    driver.navigate.to 'https://www.epicpass.com/account/my-account.aspx'

    wait.until { driver.find_element(id: 'onetrust-accept-btn-handler') }

    puts 'Filling in form'
    driver.find_element(id: 'onetrust-accept-btn-handler').click # cookie banner
    driver.find_element(id: 'txtUserName_3').send_keys(@username)
    driver.find_element(id: 'txtPassword_3').send_keys(@password)
    driver.find_element(css: '#returningCustomerForm_3 .primaryCTA').click

    wait.until { driver.find_element(css: 'h1.title') } # wait for page to load
    puts 'Logged In'

    driver.navigate.to 'https://www.epicpass.com/account/my-account.aspx?ma_1=4'
    wait.until { driver.find_element(class: 'season_passes__reservations__title--firstPass') }
    puts 'Loaded "Reservations" tab'
    driver.find_element(class: 'season_passes__reservations__title--firstPass').click

    wait.until { driver.find_element(css: '.season_passes__reservations__content__list > li') }
    reservation_list = driver.find_elements(css: '.season_passes__reservations__content__list > li')
    puts 'Loaded inner dropdown'

    reservations = reservation_list.map do |res|
      resort = res.find_element(css: 'div > div:nth-child(1)').text
      date = Date.parse(res.find_element(css: 'div > div:nth-child(2)').text)

      { resort: resort, date: date }
    end

    reservations
  rescue Selenium::WebDriver::Error::NoSuchElementError
    @retries -= 1
    retry if @retries > 0
  end
end
