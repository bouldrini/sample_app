require 'faker'

namespace :db do
desc "Fill database with sample data" 
task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:name => "Example User",
                 :email => "example@railstutorial.org",
                 :age => "19",
                 :password => "foobara",
                 :password_confirmation => "foobara")
99.times do |n|
name = Faker::Name.name
email = "example-#{n+1}@railstutorial.org" 
age = "19"
password = "password"
User.create!(:name => name,
:age => age,
:email => email,
:password => password,
:password_confirmation => password)
end 
end
end
