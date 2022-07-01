FROM elixir:1.12-alpine

RUN apk add --update-cache build-base git postgresql-client nodejs yarn bash

WORKDIR /opencov

ENV MIX_ENV prod

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs package.json ./

RUN yarn install && mix deps.get

COPY . .

RUN mix compile && mix assets.compile

CMD ["bash", "run.sh"]
