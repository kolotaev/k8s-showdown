require 'json'

require 'sinatra'


set :port, 9001

# before '/' do
#   content_type 'application/json'
# end

get '/' do
  data = {
    'name': 'time server',
    'time': Time.now,
  }
  data.to_json
end
