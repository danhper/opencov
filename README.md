# OpenCov

OpenCov is a self-hosted opensource test coverage history viewer.
It is (mostly) compatible with [coveralls](https://coveralls.io/), so most
coverage tools will work easily.

## Starting the server

```
$ npm install # (or yarn install)
$ mix deps.get
$ mix ecto.create && mix ecto.migrate
$ mix phoenix.server
```

This should start OpenCov at port 4000.

If you want to setup the server for production, you will need to run the above commands
with `MIX_ENV=prod` and to run

```
$ mix assets.compile
```

before starting the server.

You should also be able to deploy to Heroku by simply git pushing this repository.

### Configuring

The simplest way to configure the app is to create a `local.exs` in the `config`
and to override all the configuration you need.

## Sending test metrics

A few languages are documented in [the wiki](https://github.com/tuvistavie/opencov/wiki).
For other languages, coveralls instructions should work out of the box,
you just need to set the URL to your OpenCov server and to explicitly set
the token, even when using Travis.

## Demo and screenshots

A demo is available at http://demo.opencov.com, you can create an account or login with

* username: user@opencov.com
* password: password123

For "security" reasons, the user is not admin.

### Projects list

![projects](https://cloud.githubusercontent.com/assets/1436271/21740030/45ce95d6-d4ef-11e6-8d09-fac4aa7d5f00.png)

### Project page

![project page](https://cloud.githubusercontent.com/assets/1436271/21740031/45d0bafa-d4ef-11e6-93dc-0decbbd1d973.png)

### Build page

![build page](https://cloud.githubusercontent.com/assets/1436271/21740029/45cd825e-d4ef-11e6-9a55-ab19be6a3690.png)

### Coverage page

![coverage page](https://cloud.githubusercontent.com/assets/1436271/21740028/45cca55a-d4ef-11e6-9515-6b8672549dbd.png)

### Admin panel

![admin panel](https://cloud.githubusercontent.com/assets/1436271/21740375/adaaaa08-d4fb-11e6-916b-439a2eaeeb3b.png)
