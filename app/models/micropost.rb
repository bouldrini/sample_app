class Micropost < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content
  
  default_scope :order => 'microposts.created_at DESC'

  validates_presence_of :content, on: :create
  validates_length_of    :content, maximum: 400
  validates_presence_of :user_id, on: :create



end
