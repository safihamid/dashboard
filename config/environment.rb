# Load the Rails application.
deployment_path = File.expand_path('../../../deployment.rb', __FILE__)
if File.file?(deployment_path)
  require deployment_path
else
  module Deploy
    def self.config()
      {}
    end
  end
end
require File.expand_path('../application', __FILE__)

# Force UTF-8 Encodings.
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Initialize the Rails application.
Dashboard::Application.initialize!
