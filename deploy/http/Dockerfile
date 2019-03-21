FROM alpine:3.6 as builder

ADD https://releases.hashicorp.com/envconsul/0.6.2/envconsul_0.6.2_linux_amd64.tgz /tmp/envconsul.tgz
RUN tar -xvzf /tmp/envconsul.tgz -C /usr/local/bin/

FROM bitwalker/alpine-elixir-phoenix:1.6.6

ENV MIX_ENV prod

RUN apk --no-cache --update add postgresql-client yarn

COPY --from=builder /usr/local/bin/envconsul /usr/local/bin/

RUN mkdir /opencov
WORKDIR /opencov

# Install all the dependency
ADD mix.exs /opencov/mix.exs
ADD mix.lock /opencov/mix.lock
ADD package.json /opencov/package.json
ADD yarn.lock /opencov/yarn.lock

RUN yarn install
RUN mix deps.get

ADD . /opencov
RUN mix compile
RUN mix assets.compile

EXPOSE 80
ENTRYPOINT ["mix", "phx.server"]

