FROM ruby:3.0.0-alpine

WORKDIR /application

COPY Gemfile* /application/

RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev build-base yarn \
    && apk add --no-cache mariadb-dev

RUN gem install bundler:2.2.32

RUN bundle install

COPY package* yarn.lock /application/

RUN yarn install

COPY . .

CMD [ "/application/bin/rails",  "s", "--binding", "0.0.0.0", "-p", "3000" ]
# CMD [ "ping", "localhost" ]