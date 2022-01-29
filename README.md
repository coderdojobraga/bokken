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

> ⚔️  **bok**ken + shuri**ken**

[![Postman][postman-badge]][postman-documentation]
[![CI build][ci-build-status]][ci-build-workflow]
[![CI test][ci-test-status]][ci-test-workflow]
[![CI style][ci-style-status]][ci-style-workflow]

Platform support API for managing session registrations and recording ninjas'
progress.

## 📦 Deployment

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

## 🤝 Contributing

When contributing to this repository, please first discuss the change you wish
to make via discussions, issues, email, or any other method with the owners of this
repository before making a change.

Please note we have a [Code of Conduct](CODE_OF_CONDUCT.md), please follow it
in all your interactions with the project.

We have a [Contributing Guide][contributing] to help you getting started.

## 📝 License

Copyright (c) 2021, CoderDojo Braga.

This project is licensed under the MIT License - see the [LICENSE][license]
file for details.
