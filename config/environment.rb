require File.expand_path('../boot', __FILE__)

Bundler.require(:default, RAILS_ENV)

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'

  config.action_controller.session = {
    :key => '_tolk_session',
    :secret => 'f2d72b63242db79df080031c60159a419981cc6c066e961405c1a86c5c38ba56c960d6de171dc4cf985f1544c00466400abf0aac2ce1cbdb726f6127d304fb07'
  }
end
