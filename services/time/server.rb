require 'json'

require 'sinatra'


get '/' do
  before { content_type 'application/json' }

  data = {
    'name': 'time server',
    'time': Time.now,
  }
  data.to_json
end
