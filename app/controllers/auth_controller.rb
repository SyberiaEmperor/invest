class AuthController < ApplicationController
  protect_from_forgery with: :null_session

  @jwt = "JWTOKEN"

  def _refresh_token
      @jwt = "JWTOKEN"
  end

    def sign_up
        _refresh_token if @jwt.nil?
        render json: {
          login: params[:login],
          password: params[:password],
          jwt: @jwt
        }
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
    token = request.headers[:Authorization]
    if token.to_s.empty?
      head :unauthorized
      return
    end
    @jwt = nil
    head :ok
  end

end