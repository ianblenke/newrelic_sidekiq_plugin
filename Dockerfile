FROM ruby:2-onbuild
MAINTAINER Ian Blenke <ian@blenke.com>

ADD run.sh /run.sh
RUN chmod 755 /run.sh

CMD /run.sh
