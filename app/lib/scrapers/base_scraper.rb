require 'selenium-webdriver'
require 'webdrivers'
require 'fileutils'

module Scrapers
  class BaseScraper
    def initialize_webdriver
      @tmpdir = Dir.mktmpdir
      if ENV['GOOGLE_CHROME_SHIM']
        Selenium::WebDriver::Chrome.path = ENV['GOOGLE_CHROME_SHIM']
      end
      chrome_opts = Selenium::WebDriver::Chrome::Options.new
      chrome_opts.add_argument('--window-size=1440,1000')
      chrome_opts.add_argument('--disable-dev-shm-usage')
      chrome_opts.add_argument("--user-data-dir=#{@tmpdir}")

      @driver = Selenium::WebDriver.for :chrome, options: chrome_opts
    end
  end
end
