[contributing]: CONTRIBUTING.md
[code_of_conduct]: CODE_OF_CONDUCT.md
[license]: LICENSE.txt

# bokken

> :crossed_swords: **bok**ken + shuri**ken**

Platform support API for managing session registrations and recording ninjas'
progress.

## :rocket: Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes.

### :inbox_tray: Prerequisites

The following software is required to be installed on your system:

- [Erlang 23+](https://www.erlang.org/downloads)
- [Elixir 1.11+](https://elixir-lang.org/install.html)
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

### :hammer: Development

Start the development server and then you can visit
[`localhost:4000`](http://localhost:4000) from your browser.

```
bin/server
```

Run the tests.

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

### :whale: Docker

For data persistence this project uses a PostgreSQL database. You should have
PostgreSQL up and running.

If you want to setup the required database using docker containers you can
easily do it with [docker-compose](https://docs.docker.com/compose/install/).

Create and start the database containers.

```
docker-compose up -d db
```

Start the previously created containers.

```
docker-compose start
```

Stop the containers.

```
docker-compose stop
```

Destroy the containers and volumes created.

```
docker-compose down -v
```

### :package: Deployment

Ready to run in production? Please [check the official deployment
guides](https://hexdocs.pm/phoenix/deployment.html).

### :link: References

You can use these resources to learn more about the technologies this project
uses.

- [Getting Started with Elixir](https://elixir-lang.org/getting-started/introduction.html)
- [Erlang/Elixir Syntax: A Crash Course](https://elixir-lang.org/crash-course.html)
- [Elixir School Course](https://elixirschool.com/en/)
- [Phoenix Guides Overview](https://hexdocs.pm/phoenix/overview.html)
- [Phoenix Documentation](https://hexdocs.pm/phoenix)

## :handshake: Contributing

Please read [CONTRIBUTING][contributing] and [CODE_OF_CONDUCT][code_of_conduct]
for details on our code of conduct and the process for submitting pull requests
to us.

## :memo: License

This project is licensed under the MIT License - see the [LICENSE][license]
file for details.
