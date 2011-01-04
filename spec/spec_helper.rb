require 'rack/test'
set :environment, :test

module MyTestMethods
  def app
    Sinatra::Application
  end
end

Spec::Runner.configure do |config|
  config.include Rack::Test::Methods
  config.include MyTestMethods
end