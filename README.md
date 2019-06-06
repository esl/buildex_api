# BuildexApi

[![Build Status](https://travis-ci.org/esl/release_admin.svg?branch=master)](https://travis-ci.org/esl/release_admin)

# Development prerequisites

* Postgres running locally with a user/password of 'postgres'/'postgres' e.g. using docker : `docker run --name postgres -v pgdata:/var/lib/postgresql/data  -p 5432:5432 -d postgres --password -e POSTGRES_PASSWORD=postgres`

* Elixir 1.7

## Running the application

Before you start, you might want to quickly read over the Github guides to [creating an oauth application](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/), and [authorizing oauth applications](https://developer.github.com/apps/building-oauth-apps/authorizing-oauth-apps/).

You will need to create a new OAuth application on Github and provide it's `CLIENT_ID` and `CLIENT_SECRET` values to the release_admin application.

The steps involved are as follows :

## Create github application

Create a new github application via the [github.com/settings/applications/new](https://github.com/settings/applications/new)

For testing purposes we've chosen the following values, the only important value is the callback url, which is where OAuth requests will be redirected to:

![Image of Github OAuth setup](docs/github-setup-for-ueberauth.png)

Having created the application, you will be given the opportunity to copy the GITHUB_CLIENT_ID, and GITHUB_CLIENT_SECRET - Github offers the option to regenerate the secret later if need be.

## Environmental variables and their defaults (dev)

|Key|Description|Type|Default|
|`BUILDEX_DB_SECRET_KEY`|crypto key for db|See below||
|`BUILDEX_GITHUB_CLIENT_ID`|github client id|string||
|`BUILDEX_GITHUB_CLIENT_SECRET`|github client secret|string||
|`BUILDEX_NODE_COOKIE`|erlang shared cookie||
|`BUILDEX_POSTGRES_DATABASE`||
|`BUILDEX_POSTGRES_HOSTNAME`||
|`BUILDEX_POSTGRES_PASSWORD`||
|`BUILDEX_POSTGRES_USER`||
|`BUILDEX_POSTGRES_USERNAME`||
|`BUILDEX_POLLER_DOMAIN`|buildex_poller@127.0.0.1|string|
|`BUILDEX_RPC_IMPL`||

## Environmental variables and their defaults (prod)

|Key|Description|Type|Default|
|`BUILDEX_DB_SECRET_KEY`|crypto key for db|See below||
|`BUILDEX_GITHUB_CLIENT_ID`|github client id|string||
|`BUILDEX_GITHUB_CLIENT_SECRET`|github client secret|string||
|`BUILDEX_NODE_COOKIE`|erlang shared cookie||
|`BUILDEX_POSTGRES_DATABASE`||
|`BUILDEX_POSTGRES_HOSTNAME`||
|`BUILDEX_POSTGRES_PASSWORD`||
|`BUILDEX_POSTGRES_USER`||
|`BUILDEX_POSTGRES_USERNAME`||
|`BUILDEX_POLLER_DOMAIN`||
|`BUILDEX_RPC_IMPL`||

## Export environmental variables

Export these environmnental variables into the environment in which you will run the 'release_admin' application:

```
export GITHUB_CLIENT_ID=<GITHUB_CLIENT_ID>
export GITHUB_CLIENT_SECRET=<GITHUB_CLIENT_SECRET>
```

## Generate and export storage crypto key 

You will need to generate a random encryption key to prevent credentials being stolen from database backups, etc (data at rest). You can do so using the following code. 

```
iex(2)> 32 |> :crypto.strong_rand_bytes() |> Base.encode64
"VdEdsw4VChhQuVQkLxZ/BVbZ/Eayo7qThpxw2g3DKuA="
```

Once you have done so, you will need to expose the base64 value as the environmental variable `DB_SECRET_KEY` i.e: 

```
export BUILDEX_DB_SECRET_KEY="VdEdsw4VChhQuVQkLxZ/BVbZ/Eayo7qThpxw2g3DKuA="
```

## Bootstrap DB

Bootstrap the database, fetch Javascript dependencies, and start the Phoenix web server :

  * Install Elixir dependencies with `mix deps.get`
  * Create and migrate the database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `iex --name admin@127.0.0.1 --cookie secret -S mix phx.server`

## Log in and follow the auth process

Navigate to the [authorization screen](http://localhost:4000/auth/github) and follow the authorization process.

This application will ask for the [following](https://github.com/sescobb27/release_admin/blob/a881d7412e934b12533fe3a05349d81f30bfe1df/config/config.exs#L27) (read only) privileges :

1. read:user
2. user:email,
3. read:org
4. repo:status
