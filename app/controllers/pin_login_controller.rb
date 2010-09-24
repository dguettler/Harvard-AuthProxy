class PinLoginController < ApplicationController

  def validate
    @session = PinSession.new(params)

    if @session.valid?
      session[:user_id] = @session.user_id
      redirect_to(cookies[:return_to] || root_path)
    else
      redirect_to access_denied_path
    end
  end

  def access_denied
  end

end
