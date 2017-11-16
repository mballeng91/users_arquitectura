class AuthorizeApiRequest
	prepend SimpleCommand
	def initialize(headers = {})
		@headers = headers
	end
	def call
		user
	end

	private

	attr_reader :headers
	def user
		@user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
		@user || errors.add(:token, 'Invalid token') && nil
	end
	def decoded_auth_token
		@decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
	end
	def http_auth_header
		if headers['Authorization'].present?
			jwt = headers['Authorization'].split(' ').last
			#[] no encontro tokens, retorna arreglo vacio
			#Si se encuentra un token significa que el token ya es invalido
			#Si no se encuentra un token (retorna vacio) significa que el token puede ser el ultimo token o puede ser un token que haya cumplido su fecha de expedicion
			if InvalidToken.find_token(jwt) != []
				errors.add(:token, 'Invalid token')
			else
				#Crea el token si todavia no se ha cumplido su fecha de expiracion
				InvalidToken.create(token: jwt) if JsonWebToken.decode(jwt) != nil
				return jwt 
			end
		else
			errors.add(:token, 'Missing token')
		end
		nil
	   end
	end