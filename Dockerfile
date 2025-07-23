FROM ruby:3.4.4-alpine AS build

RUN apk add --no-cache \
    build-base \
    git \
    curl \
    tzdata

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install --deployment --without development test --jobs=4 --retry=3

COPY . ./

RUN addgroup -g 1001 -S ruby && \
    adduser -u 1001 -S ruby -G ruby && \
    chown -R ruby:ruby /app

USER ruby

FROM build AS base

RUN bundle exec bootsnap precompile --gemfile . || true

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
