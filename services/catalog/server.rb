require 'net/http'
require 'json'

require 'sinatra'


set :port, 9003
set :bind, '0.0.0.0'

before '/' do
  content_type 'application/json'
end

get '/' do
  res1 = Net::HTTP.get('http://greet.showdown', '/')
  res2 = Net::HTTP.get('http://time.showdown', '/')

  data = {
    'name': 'catalog server',
    'greeting': JSON.parse(res1.body)['greeting'],
    'timestamp': JSON.parse(res2.body)['ts'],
  }
  data.to_json
end
