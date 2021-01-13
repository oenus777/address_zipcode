FROM ruby:2.6.3

ENV LANG=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    LC_CTYPE="utf-8"

RUN apt-get update -qq && \
  apt-get install -y apt-utils \
  build-essential \
  libpq-dev \
  nodejs \
  vim \
  default-mysql-client 

WORKDIR /app

ADD Gemfile .
ADD Gemfile.lock .
RUN bundle update --bundler
RUN bundle install -j4

ADD . /app

RUN mkdir -p tmp/sockets

EXPOSE 3000