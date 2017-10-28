class User < ActiveRecord::Base

  has_secure_password

  has_many  :tweets

  def slug
    username.downcase.split.join("-")
  end

  def self.find_by_slug(slug)
    self.all.detect {|s| s.slug == slug}
  end

end
