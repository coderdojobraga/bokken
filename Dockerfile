FROM elixir:1.12.1-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base git python3

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# compile and build release
COPY lib lib

COPY data data

COPY priv priv

# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.13.5 AS app
RUN apk add --no-cache openssl ncurses-libs

# add imagemagick support
RUN apk add --no-cache file imagemagick

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

RUN mkdir -p /app/uploads

VOLUME ["/app/uploads"]

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/bokken ./

ENV HOME=/app

ENTRYPOINT ["bin/bokken"]
CMD ["start"]
