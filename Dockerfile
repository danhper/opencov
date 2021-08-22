FROM elixir:1.12.2-slim AS build

# install build dependencies
RUN apt update && apt install -y build-essential git

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

# build assets
# COPY assets/package.json assets/package-lock.json ./assets/
# RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
# COPY assets assets
# RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
COPY openapi.json openapi.json
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM debian:buster AS app
RUN apt update && apt install -y openssl

WORKDIR /app

# RUN chown nobody:nobody /app

# USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/librecov ./

ENV HOME=/app

CMD ["bin/librecov", "start"]