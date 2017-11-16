class InvalidToken < ApplicationRecord
	def self.find_token(token)
		where({token: token})
	end

	def self.delete_tokens
		where("created_at < ?",Time.zone.now - 1.hours).destroy_all
	end

end
