module UsersHelper

def gravatar_for(user, size = nil) 
  options = {:alt => user.name, :class => 'gravatar'}
  options[:gravatar] = {:size => size} if size.present?
  gravatar_image_tag(user.email.downcase, options)
end 

 end
