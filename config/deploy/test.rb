set :rails_env, 'production'
server 'ec2-54-80-1-183.compute-1.amazonaws.com', :app, :web, :db, :primary => true
