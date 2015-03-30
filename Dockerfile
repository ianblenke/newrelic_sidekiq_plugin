FROM ruby:2
MAINTAINER Ian Blenke <ian@blenke.com>
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Build.Gemfile /usr/src/app/
COPY Build.Gemfile.lock /usr/src/app/
RUN bundle config --global gemfile /usr/src/app/Bundle.Gemfile
RUN bundle install

COPY . /usr/src/app

ADD run.sh /run.sh
RUN chmod 755 /run.sh

CMD /run.sh
