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
	COMMAND="$COMMAND --config-file=$PLUGIN_CONFIG"
fi
COMMAND="$COMMAND --format=${PLUGIN_FORMAT:-colored}"
if [[ "${PLUGIN_STRICT:-true}" == "true" ]]; then
	COMMAND="$COMMAND --strict"
fi
if [[ "${PLUGIN_NO_WARNINGS:-}" == "true" ]]; then
	COMMAND="$COMMAND --no-warnings"
fi
COMMAND="$COMMAND $(pwd)"

# custom args, e.g. docker run --rm --volume=$(pwd):$(pwd) --workdir=$(pwd) --env=CI=test kokuwaio/yamllint --format=json
if [[ -n "${1:-}" ]]; then
	COMMAND="$COMMAND $*"
fi

##
## evecute command
##

echo "$COMMAND"
eval "$COMMAND"
