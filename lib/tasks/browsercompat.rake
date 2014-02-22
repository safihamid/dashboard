if Rails.env.development?
  require 'rubygems'
  require 'cucumber'
  require 'cucumber/rake/task'
  require 'json'

  @browsers = JSON.load(open("#{Rails.root}/lib/tasks/browsers.json"))

  task :browsercompat do
    @browsers.each do |browser|
      begin
        puts "Running with: #{browser.inspect}"
        ENV['SELENIUM_BROWSER'] = browser['browser']
        ENV['SELENIUM_VERSION'] = browser['browser_version']
        ENV['BS_AUTOMATE_OS'] = browser['os']
        ENV['BS_AUTOMATE_OS_VERSION'] = browser['os_version']
        ENV['BS_ORIENTATION'] = browser['deviceOrientation']

        Rake::Task["cucumber:ok"].reenable
        Rake::Task["cucumber:ok"].invoke
      end
    end
  end

  task :default => [:browsercompat]
end