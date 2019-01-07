# base image elixer to start with
FROM bitwalker/alpine-elixir:1.7.4

# install hex package manager
RUN mix local.hex --force

# install phoenix
# this only works for phx >= 1.4.0
# RUN mix archive.install hex phx_new 1.3.4 --force
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new-1.3.4.ez

# install node
RUN apk update && \
    apk --no-cache --update add \
      git make g++ wget curl inotify-tools \
      nodejs nodejs-npm && \
    npm install npm -g --no-progress && \
    update-ca-certificates --fresh && \
    rm -rf /var/cache/apk/*

# create app folder
RUN mkdir /app
COPY . /app
WORKDIR /app

# setting the port and the environment (prod = PRODUCTION!)
ENV MIX_ENV=prod
ENV PORT=4000

# install dependencies (production only)
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix compile

# install node dependencies and build only the things for production
RUN cd assets && \
    npm install && \
    ./node_modules/.bin/brunch build --production

# create the digests
RUN mix phx.digest

# create release
RUN mix release

ENTRYPOINT ["_build/prod/rel/release_admin/bin/release_admin"]

# run phoenix in production on PORT 4000
CMD ["foreground"]
