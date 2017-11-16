class ApplicationController < ActionController::API
	before_action :authenticate_request
	attr_reader :current_user
	#undef_method :current_user
	ActiveModelSerializers.config.adapter = :json
  	#respond_to :json

	private
	
	def authenticate_request
		#recibo del cliente(request)
		 @current_user = AuthorizeApiRequest.call(request.headers).result
		 if @current_user
		 	#Crea el nuevo token
		 	response.headers["jwt"] = JsonWebToken.encode(user_id: @current_user.id)
		 else
		 	render json: { error: 'Not Authorized' }, status: 401
		 end
	end
end
