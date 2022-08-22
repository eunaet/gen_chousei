require 'capybara'
require 'webdrivers/chromedriver'

Capybara.threadsafe = true

def init_session
  Capybara::Session.new(:selenium_chrome_headless) do |config|
    config.run_server = false
    config.app_host = 'https://chouseisan.com'
  end
end
