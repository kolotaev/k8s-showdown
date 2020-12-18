FROM ruby:2.5-alpine

RUN gem install sinatra
ADD server.rb server.rb
EXPOSE 9001
CMD ["ruby", "server.rb"]
