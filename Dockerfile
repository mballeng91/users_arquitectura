

FROM ruby:2.2.6

RUN mkdir /ms_autenticateuser
WORKDIR /ms_autenticateuser

ADD Gemfile /ms_autenticateuser/Gemfile
ADD Gemfile.lock /ms_autenticateuser/Gemfile.lock

RUN bundle install
ADD . /ms_autenticateuser
