ARG MIX_ENV="prod"

FROM elixir:1.12.3-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base git python3

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ARG MIX_ENV
ENV MIX_ENV=$MIX_ENV

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get --only $MIX_ENV, deps.compile

# compile and build release
COPY lib lib

COPY data data

COPY priv priv

# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.14 AS app

ARG MIX_ENV

RUN apk add --no-cache openssl ncurses-libs

# add imagemagick support
RUN apk add --no-cache file imagemagick

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

RUN mkdir -p /app/uploads

VOLUME ["/app/uploads"]

COPY --from=build --chown=nobody:nobody /app/_build/$MIX_ENV/rel/bokken ./

ENV HOME=/app

ENTRYPOINT ["bin/bokken"]
CMD ["start"]
