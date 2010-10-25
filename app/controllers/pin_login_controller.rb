class PinLoginController < ApplicationController

  skip_before_filter :require_login, :authentication, :authorization
  before_filter :set_harvard_pin_preference

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

  protected
    def set_harvard_pin_preference
      preferences = ActiveSupport::JSON.decode(cookies['preferences'] || '{}')
      cookies['preferences'] = ActiveSupport::JSON.encode(preferences.merge!({ 'harvard_pin' => true }))
    end

end
