FROM elixir:1.18-alpine as dev

RUN apk --update --no-cache add bash git

WORKDIR /app

RUN mix do local.hex --force, local.rebar --force

COPY .env ./

ENV MIX_ENV=dev

COPY mix.exs mix.lock .formatter.exs ./

RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

CMD mix run --no-halt