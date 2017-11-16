require 'net/ldap'

class UsersController < ApplicationController
before_action :set_user, only: [:show, :update, :destroy]
  #before_action :authenticate_user, except:[:index]
  skip_before_action :authenticate_request, only:[:create, :connect]

  # GET /users
 def connect
   ldap = Net::LDAP.new(
     host:'192.168.99.102',
     port: 389,
     auth: {
       method: :simple,
       dn: "cn=admin, dc=arqsoft, dc=unal, dc=edu, dc=co",
       password: "admin"
     }
   )
   puts "lo que retorna ldap.bind"
   puts ldap.bind
   return ldap.bind

 end


  def index
    @users = User.all

    puts "serializador user"
    puts UserSerializer
    render json: @users, each_serializer:UserSerializer

  end

  # GET /users/1
  def show
    render json: @user,serializer:UserSerializer
  end

  def testSession
    # email = params[:email].to_s
    # password = params[:password].to_s
		# if connect()
    #   puts "me conecte"
    #   ldap = Net::LDAP.new(
    #
    #     host: '192.168.99.102',
    #     port: 389,
    #     auth: {
    #       method: :simple,
    #       dn: 'cn=' + email +',ou=Shop,dc=arqsoft,dc=unal,dc=edu,dc=co',
    #       password: password
    #     }
    #   )
       #if ldap.bind
				render json: current_user, serializer: UserSerializer
       #else
        #   render json: {userValid: false}
       #end
  #  end
end

  def logout
    response.headers["jwt"] = nil
    render json: {message: "logout successful"}, status: :ok
  end
  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      if connect()
        puts "me conecte"
        ldap = Net::LDAP.new(
          host:'192.168.99.102',
          port: 389,
          auth: {
            method: :simple,
            dn: "cn=admin, dc=arqsoft, dc=unal, dc=edu, dc=co",
            password: "admin"
          }
        )
        if ldap.bind
          pass = Net::LDAP::Password.generate(:md5, params[:user][:password])

          attr = { :cn => params[:user][:email],  :sn => params[:user][:first_name]   ,  :objectClass =>["inetOrgPerson","posixAccount","top" ] , :uid =>params[:user][:email] , :uidNumber => @user.id.to_s, :gidNumber =>"500" ,:homeDirectory => "/home/users/"+params[:user][:email] , :userpassword=> pass}
          dn = "cn=" + params[:user][:email] + ",ou=Shop , dc=arqsoft,dc=unal, dc=edu, dc=co"
          puts attr
          ldap.add(:dn => dn, :attributes => attr)

        end
      end
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end




  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def search

    if params.has_key?(:q)
        @users_name = User.users_by_name("%#{params[:q]}%")
#       render json: @products, :include => [:product]
       render json: @users_name, each_serializer:UserSerializer

    else
        @users = User.all

    end
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :age, :password, :password_confirmation)
    end
end
