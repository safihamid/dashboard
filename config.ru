# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
begin
  require 'unicorn/oob_gc'
  use Unicorn::OobGC
  rescue LoadError
end


run Rails.application
