class AuthController < ApplicationController
  protect_from_forgery with: :null_session


    def sign_up
      @user = User.new(user_params)
      if @user.save
        token = ApplicationHelper::JsonWebToken.encode(user_id: @user.id)
        render json: {
          token: token
        }, status: :created
      else
        render json: {
          errors: @user.errors.full_messages
        },
               status: :unprocessable_entity
      end
    end




  #TODO: Прям ваще одинаковый код нарисовывается, надо бы подумать
    def sign_in
      @user = User.find_by_login(params[:login])
      if @user&.authenticate(params[:password])
        token = ApplicationHelper::JsonWebToken.encode(user_id: @user.id)
        render json: {
          token: token
        }
      else
        render json: {
          error: :unauthorized
        }, status: :unauthorized
      end
    end


  private
  def user_params
    # strong parameters
    params.permit(:login, :password)
  end

end