require 'selenium-webdriver'
require 'webdrivers'

def drive(username, password)
  caps = Selenium::WebDriver::Remote::Capabilities.new
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--start-maximized')

  driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps, options: options
  driver.navigate.to 'https://www.epicpass.com/account/my-account.aspx'

  driver.find_element(id: 'onetrust-accept-btn-handler').click # cookie banner
  driver.find_element(id: 'txtUserName_3').send_keys(username)
  driver.find_element(id: 'txtPassword_3').send_keys(password)
  driver.find_element(css: '#returningCustomerForm_3 .primaryCTA').click

  wait = Selenium::WebDriver::Wait.new(timeout: 10)
  wait.until { driver.find_element(css: 'h1.title') } # wait for page to load

  driver.navigate.to 'https://www.epicpass.com/account/my-account.aspx?ma_1=4'
  wait.until { driver.find_element(class: 'season_passes__reservations__title--firstPass') }
  driver.find_element(class: 'season_passes__reservations__title--firstPass').click

  wait.until { driver.find_element(css: '.season_passes__reservations__content__list > li') }
  reservation_list = driver.find_elements(css: '.season_passes__reservations__content__list > li')

  reservations = reservation_list.map do |res|
    resort = res.find_element(css: 'div > div:nth-child(1)').text
    date = Date.parse(res.find_element(css: 'div > div:nth-child(2)').text)

    { resort: resort, date: date }
  end
  return reservations
rescue => ex
  Rails.logger.error(ex)
end

drive('tomdooner@gmail.com', ENV['EPICMIX_PASSWORD'])
