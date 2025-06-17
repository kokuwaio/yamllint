#!/bin/bash
set -eu;

##
## check if any yaml file is present
##

FILES=$(find "$(pwd)" -type f -name '*.yml' -o -name '*.yaml')
if [[ ! "$FILES" ]]; then
	echo "No yaml file found!"
	exit 1
fi

##
## build command
##

COMMAND="yamllint"
if [[ -n "${PLUGIN_CONFIG_FILE:-}" ]]; then
	COMMAND+=" --config-file=$PLUGIN_CONFIG"
fi
COMMAND+=" --format=${PLUGIN_FORMAT:-colored}"
if [[ "${PLUGIN_STRICT:-true}" == "true" ]]; then
	COMMAND+=" --strict"
fi
if [[ "${PLUGIN_NO_WARNINGS:-}" == "true" ]]; then
	COMMAND+=" --no-warnings"
fi
COMMAND+=" $(pwd)"

# custom args, e.g. docker run --rm --volume=$(pwd):$(pwd) --workdir=$(pwd) --env=CI=test kokuwaio/yamllint --format=json
if [[ -n "${1:-}" ]]; then
	COMMAND+=" $*"
fi

##
## execute command
##

echo "$COMMAND"
eval "$COMMAND"
