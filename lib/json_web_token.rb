class JsonWebToken
    class << self
        #id usuario: payload
        def encode(payload, exp = 1.hours.from_now)
            payload[:exp] = exp.to_i
            JWT.encode(payload, Rails.application.secrets.secret_key_base,'HS256')
        end

        def decode(token)
            body = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { :algorithm => 'HS256' })[0]
            HashWithIndifferentAccess.new body
        rescue
            #si ya expiro el token retorna nil
            nil
        end
    end 
end 
