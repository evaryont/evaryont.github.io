FROM ruby:2.3-alpine
MAINTAINER Evaryont <colin@evaryont.me>

RUN apk add --update build-base libxml2-dev libxslt-dev
#RUN apk add --update \
#      bash \
#      ca-certificates \
#      libxml2 \
#      libxslt \
#      gcc \
#      ruby \
#      ruby-dev \

COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install

ENV web /www
RUN mkdir $web
WORKDIR $web
ADD . $web

CMD rake build
