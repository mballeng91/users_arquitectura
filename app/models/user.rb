class User < ApplicationRecord
	has_secure_password
  
  def self.users_by_name(word)     
      where("users.first_name LIKE ?",word)
  end
    
end
