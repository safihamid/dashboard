require 'selenium/webdriver'

browser = Selenium::WebDriver.for :chrome, :url=>"http://127.0.0.1:9515"

puts browser

Before do |scenario|
  @browser = browser
end

at_exit do
  browser.quit
end

