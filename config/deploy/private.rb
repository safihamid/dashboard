set :rails_env, 'production'
server 'ec2-50-17-122-132.compute-1.amazonaws.com', :app, :web, :db, :primary => true
