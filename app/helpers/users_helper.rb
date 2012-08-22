module UsersHelper

def gravatar_for(user, size, options = { :size => size }) 
  gravatar_image_tag(user.email.downcase,     :alt        => user.name,
                                              :class      => 'gravatar',
                                              :gravatar   => options)
end


end
