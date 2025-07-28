FROM ruby:3.4.4-alpine AS build

RUN apk add --no-cache \
    build-base \
    git \
    curl \
    tzdata

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN mkdir -p tmp/pids

RUN bundle install --deployment --without development test --jobs=4 --retry=3

COPY . ./

RUN addgroup -g 1001 -S ruby && \
    adduser -u 1001 -S ruby -G ruby && \
    chown -R ruby:ruby /app

USER ruby

FROM build AS base

# Health check
HEALTHCHECK --interval=10s --timeout=1s --start-period=3s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:${PORT:-3000}/health || exit 1

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
