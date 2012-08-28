require 'faker'

namespace :db do
desc "Fill database with sample data" 
task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Walter White",
                 :email => "richardwieditz@gmail.com",
                 :age => "50",
                 :password => "walter",
                 :password_confirmation => "walter")
admin.toggle!(:admin)
99.times do |n|
name = Faker::Name.name
email = "example-#{n+1}@railstutorial.org" 
age = 18 + Random.rand(33)
password = "password"
User.create!(:name => name,
:age => age,
:email => email,
:password => password,
:password_confirmation => password)
end 
end
end
