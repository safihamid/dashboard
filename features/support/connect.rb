require 'selenium/webdriver'

class Object
  def nil_or_empty?()
    self.nil? || self.empty?
  end
end

=begin
### This drives a local installation of ChromeDriver running on port 9515, instead of BrowserStack.
rescue Exception => e 
end
browser = Selenium::WebDriver.for :chrome, :url=>"http://127.0.0.1:9515"
=end


### browserstack
if ENV['BROWSERSTACK_USERNAME'].nil_or_empty? || ENV['BROWSERSTACK_AUTHKEY'].nil_or_empty?
  raise "Missing BrowserStack credentials in environment."
end

url = "http://#{ENV['BROWSERSTACK_USERNAME']}:#{ENV['BROWSERSTACK_AUTHKEY']}@hub.browserstack.com/wd/hub"
capabilities = Selenium::WebDriver::Remote::Capabilities.new
capabilities["browserstack.debug"] = "true"

capabilities = Selenium::WebDriver::Remote::Capabilities.new
capabilities['os'] = ENV['BS_AUTOMATE_OS']
capabilities['os_version'] = ENV['BS_AUTOMATE_OS_VERSION']
capabilities['browser'] = ENV['SELENIUM_BROWSER']
capabilities['browser_version'] = ENV['SELENIUM_VERSION']
capabilities['browserstack.debug'] = "true"

capabilities['project'] = ENV['BS_AUTOMATE_PROJECT'] if ENV['BS_AUTOMATE_PROJECT']
capabilities['build'] = ENV['BS_AUTOMATE_BUILD'] if ENV['BS_AUTOMATE_BUILD']

capabilities['rotatable'] = ENV['BS_ROTATABLE'] if ENV['BS_ROTATABLE']
capabilities['deviceOrientation'] = ENV['BS_ORIENTATION'] if ENV['BS_ORIENTATION']

capabilities['browserstack.tunnel'] = 'true'


browser = Selenium::WebDriver.for(:remote, :url => url, :desired_capabilities => capabilities)


### common
Before do |scenario|
  @browser = browser
end
at_exit do
  browser.quit
end
