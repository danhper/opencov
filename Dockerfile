# Cannot upgrade to 1.12 (erlang 24) because pubsub p2 child process handling
FROM elixir:1.8-alpine

RUN apk add --update-cache build-base git postgresql-client nodejs yarn

WORKDIR /opencov

ENV MIX_ENV prod

RUN mix local.hex --force && mix local.rebar --force

COPY package.json ./
RUN yarn install

COPY . .
RUN mix deps.get


RUN mix compile && mix assets.compile

CMD ["mix", "phx.server"]
