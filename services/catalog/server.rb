require 'net/http'
require 'json'

require 'sinatra'


set :port, 9003
set :bind, '0.0.0.0'

before '/' do
  content_type 'application/json'
end

get '/' do
  res1 = Net::HTTP.get(ENV['GREET_URL'], "/?name=#{SecureRandom.alphanumeric}")
  res2 = Net::HTTP.get(ENV['TIME_URL'], '/')
  res3 = Net::HTTP.get_response(ENV['NODE_IP'], "/", ENV['WORKY_PORT'])

  data = {
    'name': 'catalog server',
    'greeting': JSON.parse(res1)['greeting'],
    'ts': JSON.parse(res2)['timestamp'],
    'aggregate': true,
    'worky': res3&.body,
  }
  data.to_json
end
