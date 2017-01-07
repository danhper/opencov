FROM elixir:1.4

ENV MIX_ENV prod

RUN apt-get update -qq && apt-get install -y apt-transport-https

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -

RUN apt-get install -y build-essential postgresql-client nodejs yarn

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mkdir /opencov
WORKDIR /opencov

ADD mix.exs /opencov/mix.exs
ADD mix.lock /opencov/mix.lock
ADD package.json /opencov/package.json
ADD yarn.lock /opencov/yarn.lock

RUN yarn install
RUN mix deps.get

ADD . /opencov
RUN mix compile
RUN mix assets.compile
