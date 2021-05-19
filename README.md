[postman-badge]: https://img.shields.io/badge/Postman-ef5b25.svg?logo=postman&colorA=ef5b25&logoColor=white
[postman-documentation]: https://documenter.getpostman.com/view/14049085/TzCTXj9E
[ci-build-status]: https://github.com/coderdojobraga/bokken/actions/workflows/build.yml/badge.svg
[ci-build-workflow]: https://github.com/coderdojobraga/bokken/actions/workflows/build.yml
[ci-test-status]: https://github.com/coderdojobraga/bokken/actions/workflows/test.yml/badge.svg
[ci-test-workflow]: https://github.com/coderdojobraga/bokken/actions/workflows/test.yml
[ci-style-status]: https://github.com/coderdojobraga/bokken/actions/workflows/style.yml/badge.svg
[ci-style-workflow]: https://github.com/coderdojobraga/bokken/actions/workflows/style.yml
[contributing]: CONTRIBUTING.md
[code_of_conduct]: CODE_OF_CONDUCT.md
[license]: LICENSE.txt

# bokken

> :crossed_swords: **bok**ken + shuri**ken**

[![Postman][postman-badge]][postman-documentation]
[![CI build][ci-build-status]][ci-build-workflow]
[![CI test][ci-test-status]][ci-test-workflow]
[![CI style][ci-test-status]][ci-style-workflow]

Platform support API for managing session registrations and recording ninjas'
progress.

## :rocket: Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes.

### :inbox_tray: Prerequisites

The following software is required to be installed on your system:

- [Erlang 24+](https://www.erlang.org/downloads)
- [Elixir 1.12+](https://elixir-lang.org/install.html)
- [PostgreSQL 13+](https://www.postgresql.org/download/)

We recommend using [asdf version
manager](https://asdf-vm.com/#/core-manage-asdf?id=install) to install and
manage all the programming languages' requirements.

### :gear: Setup

First, clone & setup the repository:

```
git clone git@github.com:coderdojobraga/bokken.git
cd bokken
bin/setup
```

If you want use different ENV variables, you have to export the `.env.dev`. You
can do that using [direnv](https://direnv.net/).

### :hammer: Development

Start the development server and then you can visit
[`localhost:4000`](http://localhost:4000) from your browser.

```
bin/server
```

Run the tests. You need to have [newman](https://www.npmjs.com/package/newman)
installed.

```
bin/test
```

Lint your code.

```
bin/lint
```

Format your code.

```
bin/format
```

###  :hammer_and_wrench: Tools

As a complementary tool for development and testing, we use
[Postman](https://www.postman.com/downloads/).

### :whale: Docker

For data persistence this project uses a PostgreSQL database. You should have
PostgreSQL up and running.

If you want to setup the required database using docker containers you can
easily do it with [docker-compose](https://docs.docker.com/compose/install/).

Create and start the database containers.

```
docker-compose -f docker-compose.dev.yml up -d db
```

Start the previously created containers.

```
docker-compose -f docker-compose.dev.yml start
```

Stop the containers.

```
docker-compose -f docker-compose.dev.yml stop
```

Destroy the containers and volumes created.

```
docker-compose -f docker-compose.dev.yml down -v
```

### :package: Deployment

To release a new version you can run the following script. Make sure you
update the project version number in the `mix.exs` file in advance.

```
bin/release
```

You can deploy with the help of docker containers using the following script.

```
bin/deploy (prod | stg)
```

Please [check the official deployment
guides](https://hexdocs.pm/phoenix/deployment.html) for more information.

## :handshake: Contributing

Please read [CONTRIBUTING][contributing] and [CODE_OF_CONDUCT][code_of_conduct]
for details on our code of conduct and the process for submitting pull requests
to us.

### :link: References

You can use these resources to learn more about the technologies this project
uses.

- [Getting Started with Elixir](https://elixir-lang.org/getting-started/introduction.html)
- [Erlang/Elixir Syntax: A Crash Course](https://elixir-lang.org/crash-course.html)
- [Elixir School Course](https://elixirschool.com/en/)
- [Phoenix Guides Overview](https://hexdocs.pm/phoenix/overview.html)
- [Phoenix Documentation](https://hexdocs.pm/phoenix)

## :memo: License

This project is licensed under the MIT License - see the [LICENSE][license]
file for details.
