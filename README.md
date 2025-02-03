# Yamllint Plugin

[![pulls](https://img.shields.io/docker/pulls/kokuwaio/yamllint)](https://hub.docker.com/repository/docker/kokuwaio/yamllint)
[![size](https://img.shields.io/docker/image-size/kokuwaio/yamllint)](https://hub.docker.com/repository/docker/kokuwaio/yamllint)
[![dockerfile](https://img.shields.io/badge/source-Dockerfile%20-blue)](https://github.com/kokuwaio/yamllint/blob/main/Dockerfile)
[![license](https://img.shields.io/github/license/kokuwaio/yamllint)](https://github.com/kokuwaio/yamllint/blob/main/LICENSE)
[![issues](https://img.shields.io/github/issues/kokuwaio/yamllint)](https://github.com/kokuwaio/yamllint/issues)

A [Woodpecker CI](https://woodpecker-ci.org) plugin for [yamllint](https://github.com/adrienverge/yamllint) to lint yaml files.
Also usable with Gitlab, Github or locally, see examples for usage.

## Features

- preconfigure yamllint parameters
- searches for yaml files recursive
- runnable with local docker daemon

## Example

Woodpecker:

```yaml
steps:
  yamllint:
    image: kokuwaio/yamllint
    depends_on: []
    settings:
      no-warnings: true
      format: json
    when:
      event: pull_request
      path: [.yamllint.yaml, "**/*.y*ml"]
```

Gitlab:

```yaml
yamllint:
  stage: lint
  needs: []
  image: kokuwaio/yamllint
  variables:
    PLUGIN_NO_WARNINGS: true
    PLUGIN_FORMAT: json
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
      changes: [.yamllint.yaml, "**/*.y*ml"]
```

CLI:

```bash
docker run --rm --volume=$(pwd):$(pwd):ro --workdir=$(pwd) kokuwaio/yamllint --no-warnings --format=json
```

## Settings

| Settings Name | Environment        | Default   | Description                                                          |
| --------------| ------------------ | --------- | -------------------------------------------------------------------- |
| `config-file` | PLUGIN_CONFIG_FILE | `none`    | Configuration file to use, if none is configured [default](https://yamllint.readthedocs.io/en/stable/configuration.html) is used |
| `strict`      | PLUGIN_STRICT      | `true`    | Fail on warnings                                                     |
| `no-warnings` | PLUGIN_NO_WARNINGS | `false`   | Output only error level problems                                     |
| `format`      | PLUGIN_FORMAT      | `colored` | Format for parsing output: parsable, standard, colored, github, auto |

## Alternatives

| Image                                                                               | Comment                           | amd64 | arm64 |
| ----------------------------------------------------------------------------------- | --------------------------------- |:-----:|:-----:|
| [kokuwaio/yamllint](https://hub.docker.com/r/kokuwaio/yamllint)                     | Woodpecker plugin                 | [![size](https://img.shields.io/docker/image-size/kokuwaio/yamllint?arch=amd64&label=)](https://hub.docker.com/repository/docker/kokuwaio/yamllint) | [![size](https://img.shields.io/docker/image-size/kokuwaio/yamllint?arch=arm64&label=)](https://hub.docker.com/repository/docker/kokuwaio/yamllint) |
| [pipelinecomponents/yamllint](https://hub.docker.com/r/pipelinecomponents/yamllint) | not a Woodpecker plugin           | [![size](https://img.shields.io/docker/image-size/pipelinecomponents/yamllint?arch=amd64&label=)](https://hub.docker.com/repository/docker/pipelinecomponents/yamllint) | [![size](https://img.shields.io/docker/image-size/pipelinecomponents/yamllint?arch=arm64&label=)](https://hub.docker.com/repository/docker/pipelinecomponents/yamllint) |
| [giantswarm/yamllint](https://hub.docker.com/r/giantswarm/yamllint)                 | not a Woodpecker plugin           | [![size](https://img.shields.io/docker/image-size/giantswarm/yamllint?arch=amd64&label=)](https://hub.docker.com/repository/docker/giantswarm/yamllint) | [![size](https://img.shields.io/docker/image-size/giantswarm/yamllint?arch=arm64&label=)](https://hub.docker.com/repository/docker/giantswarm/yamllint) |
| [cytopia/yamllint](https://hub.docker.com/r/sdesbure/yamllint)                      | not a Woodpecker plugin, outdated | [![size](https://img.shields.io/docker/image-size/cytopia/yamllint?arch=amd64&label=)](https://hub.docker.com/repository/docker/cytopia/yamllint) | [![size](https://img.shields.io/docker/image-size/cytopia/yamllint?arch=arm64&label=)](https://hub.docker.com/repository/docker/cytopia/yamllint) |
| [sdesbure/yamllint](https://hub.docker.com/r/sdesbure/yamllint)                     | not a Woodpecker plugin, outdated | [![size](https://img.shields.io/docker/image-size/sdesbure/yamllint?arch=amd64&label=)](https://hub.docker.com/repository/docker/sdesbure/yamllint) | [![size](https://img.shields.io/docker/image-size/sdesbure/yamllint?arch=arm64&label=)](https://hub.docker.com/repository/docker/sdesbure/yamllint) |
