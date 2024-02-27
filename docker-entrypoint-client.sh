#!/usr/bin/env bash

set -e
umask 002
export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH

bundle install --retry 1 --jobs 2

exec "$@"