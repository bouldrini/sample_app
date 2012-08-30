##REQUIREMENTS##
require 'digest'

class User < ActiveRecord::Base

  scope :admin, where('admin == ?', true).limit(5).order(:lastname)

  attr_accessor :password, :password_confirmation
  attr_accessible :age, :email, :name, :password, :password_confirmation

  has_many    :microposts,                :dependent => :destroy

  has_many    :relationships,             :foreign_key => "follower_id", 
                                          :dependent => :destroy

  has_many    :reverse_relationships,     :foreign_key => "followed_id",
                                          :class_name => "Relationship",
                                          :dependent => :destroy

  has_many    :following,                 :through => :relationships, 
                                          :source => :followed

  has_many    :followers,                 :through => :reverse_relationships, 
                                          :source => :follower

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates   :name,                      :presence       =>  true,
                                          :length         =>  { :maximum => 50 }

  validates   :email,                     :presence       =>  true,
                                          :format         =>  { :with => EMAIL_REGEX }, 
                                          :uniqueness     =>  { :case_sensitive => false }   
                                                              

  validates_presence_of :age, on: :create
  validates_inclusion_of :age, :in => 18..55
  
  validates_presence_of :password, on: :create
  validates_confirmation_of :password, if: :should_set_password?
  validates_presence_of :password_confirmation, if: :should_set_password?
  validates_length_of :password, minimum: 6, if: :should_set_password?

  before_save     :encrypt_password

  def feed
    Micropost.from_users_followed_by(self)
  end

  def has_password?(submitted_password) 
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt) 
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil 
  end

  def following?(followed) 
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
   relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed) 
    relationships.find_by_followed_id(followed).destroy
  end

  private

  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password) if password.present?
  end


  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end


  def make_salt 
    secure_hash("#{Time.now.utc}--#{password}")
  end


  def secure_hash(string) 
    Digest::SHA2.hexdigest(string)
  end

  def should_set_password?
    new_record? || password.present?
  end
end

