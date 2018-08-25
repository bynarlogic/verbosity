FROM ruby:alpine

ENV APP_ROOT /var/www/verbosity

RUN mkdir -p $APP_ROOT/tmp/pids

WORKDIR $APP_ROOT

COPY . .

RUN gem install bundler

RUN bundle install


