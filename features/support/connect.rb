require 'selenium/webdriver'

=begin
	
rescue Exception => e
	
end
browser = Selenium::WebDriver.for :chrome, :url=>"http://127.0.0.1:9515"

puts browser

Before do |scenario|
  @browser = browser
end

at_exit do
  browser.quit
end

=end


url = "http://#{ENV['BROWSERSTACK_USERNAME']}:#{ENV['BROWSERSTACK_AUTHKEY']}@hub.browserstack.com/wd/hub"

capabilities = Selenium::WebDriver::Remote::Capabilities.new

capabilities['project'] = ENV['BS_AUTOMATE_PROJECT'] if ENV['BS_AUTOMATE_PROJECT']
capabilities['build'] = ENV['BS_AUTOMATE_BUILD'] if ENV['BS_AUTOMATE_BUILD']

if ENV['BS_AUTOMATE_OS']
  capabilities['os'] = ENV['BS_AUTOMATE_OS']
  capabilities['os_version'] = ENV['BS_AUTOMATE_OS_VERSION']
else
  capabilities['platform'] = ENV['SELENIUM_PLATFORM'] || 'ANY'
end

capabilities['browser'] = ENV['SELENIUM_BROWSER'] || 'chrome'
capabilities['browser_version'] = ENV['SELENIUM_VERSION'] if ENV['SELENIUM_VERSION']

capabilities["browserstack.debug"] = "true"

capabilities['browserstack.tunnel'] = 'true'

# quick hack for iphone
#capabilities['browser'] = 'iPhone'
#capabilities['platform'] = 'MAC'
#capabilities['device'] = 'iPhone 5'
#capabilities['rotatable'] = true

browser = Selenium::WebDriver.for(:remote, :url => url, :desired_capabilities => capabilities)

Before do |scenario|
  @browser = browser
end

at_exit do
  browser.quit
end
