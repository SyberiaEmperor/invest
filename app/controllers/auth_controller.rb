class AuthController < ApplicationController
  protect_from_forgery with: :null_session





    def sign_up
      @user = User.new(user_params)
      if @user.save
        token = ApplicationHelper::JsonWebToken.encode(user_id: @user.id)
        render json: {
          token: token
        }
      else
        render json: {
          errors: @user.errors.full_messages
        },
               status: :unprocessable_entity
      end
    end

  private
  def user_params
    # strong parameters
    params.permit(:login, :password)
  end


  #TODO: Прям ваще одинаковый код нарисовывается, надо бы подумать
    def sign_in
        _refresh_token if @jwt == nil
        render json: {
          login: params[:login],
          password: params[:password],
          jwt: @jwt
        }
    end

  def sign_out
    :authorize_request
    # TODO: Подумать как это сделать
    @jwt = nil
    head :ok
  end

end