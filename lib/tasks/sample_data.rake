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

User.all(:limit => 6).each do |user|
50.times do
user.microposts.create!(:content => Faker::Lorem.sentence(10))
end
end
end 
end
end
