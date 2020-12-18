FROM ruby:2.5-alpine

RUN gem install sinatra
ADD server.rb server.rb
CMD ["ruby", "server.rb"]
EXPOSE 9001
