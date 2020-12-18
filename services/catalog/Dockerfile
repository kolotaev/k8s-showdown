FROM ruby:2.5-alpine

RUN gem install sinatra
ADD server.rb server.rb
EXPOSE 4567
CMD ["ruby", "server.rb"]
