ActionController::Routing::Routes.draw do |map|

  map.with_options({ :controller => 'pin_login', :conditions => { :method => :get } }) do |pin|
    pin.pin_login     '/pin_login',     :action => 'validate'
    pin.access_denied '/access_denied', :action => 'access_denied'
  end

  if RAILS_ENV=='test'
    map.root :controller => 'application_controller'
  end

end
