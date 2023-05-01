# Giftlist App

Web application for GiftList system that allows teams to share their giftlists.

Please also note the Web API that it uses: https://github.com/cryptodelta2023/Giftlist

## Install

Install this application by cloning the *relevant branch* and use bundler to install specified gems from `Gemfile.lock`:

```shell
bundle install
```

## Test

This web app does not contain any tests yet :D

## Execute

Launch the application using:

```shell
rake run:dev
```

The application expects the API application to also be running (see `config/app.yml` for specifying its URL)