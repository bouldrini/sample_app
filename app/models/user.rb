##REQUIREMENTS##

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  attr_accessible :age, :email, :name, :password, :password_confirmation

                  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates       :name,                  :presence       =>  true,
                                          :length         =>  { :maximum => 50 }

  validates       :email,                 :presence       =>  true,
                                          :format         =>  { :with => EMAIL_REGEX }, 
                                          :uniqueness     =>  { :case_sensitive => false }   
                                                               
  # validates       :password,              :presence       =>  true,
  #                                         :confirmation   =>  true,
  #                                         :length         =>  { :within => 6..40 },  
  #                                         :on             =>  :create

  validates_presence_of :password, on: :create
  validates_confirmation_of :password, if: :should_set_password?
  validates_presence_of :password_confirmation, if: :should_set_password?
  validates_length_of :password, minimum: 6, if: :should_set_password?

  before_save     :encrypt_password

  def has_password?(submitted_password) 
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
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
