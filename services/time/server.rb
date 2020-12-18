require 'json'

require 'sinatra'


set :port, 9001
set :bind, '0.0.0.0'

before '/' do
  content_type 'application/json'
end

get '/' do
  time = Time.now
  data = {
    'name': 'time server',
    'time': time,
    'timestamp': time.to_i,
  }
  data.to_json
end
