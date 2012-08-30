class Micropost < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content
  
  default_scope :order => 'microposts.created_at DESC'
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  validates_presence_of :content, on: :create
  validates_length_of    :content, maximum: 1000
  validates_presence_of :user_id, on: :create

  def self.from_users_followed_by(user)
      followed_ids = user.following.map(&:id).join(", ") 
      where("user_id IN (#{followed_ids}) OR user_id = ?", user) 
  end

  private

  def self.followed_by(user)
    followed_ids = %(SELECT followed_id FROM relationships
                           WHERE follower_id = :user_id)
    where("user_id IN (#{followed_ids}) OR user_id = :user_id", 
      { :user_id => user })
  end

end
