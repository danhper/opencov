FROM bitwalker/alpine-elixir-phoenix:latest

ENV MIX_ENV prod

RUN apk --no-cache --update add postgresql-client yarn

RUN mkdir /opencov
WORKDIR /opencov

# Install all the dependency
COPY deploy/_output/envconsul /envconsul

ADD mix.exs /opencov/mix.exs
ADD mix.lock /opencov/mix.lock
ADD package.json /opencov/package.json
ADD yarn.lock /opencov/yarn.lock

RUN yarn install
RUN mix deps.get

ADD . /opencov
RUN mix compile
RUN mix assets.compile

EXPOSE 4000
ENTRYPOINT ["mix", "phx.server"]

