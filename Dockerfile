FROM elixir:1.12-alpine

RUN apk add --update-cache build-base git postgresql-client nodejs yarn

WORKDIR /opencov

ENV MIX_ENV prod

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock package.json yarn.lock ./

RUN yarn install && mix deps.get

COPY . .

RUN mix compile && mix assets.compile

CMD ["mix", "phx.server"]
