
require 'jwt'
require_relative '../helpers/application_helper'

class ApplicationController < ActionController::Base

  def not_found
    render json: {error: 'not_found'}
  end

  def authorize_request
    header = request.headers[:Authorization]
    header = header.split(' ').last if header
    begin
      @decoded = ApplicationHelper::JsonWebToken.decode(header)
      p @decoded
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: {errors: e.message}, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: {errors: e.message}, status: :unauthorized
    end
  end
end
