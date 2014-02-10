set :rails_env, 'staging'
server "ec2-54-204-150-200.compute-1.amazonaws.com", :app, :web, :db, :primary => true
