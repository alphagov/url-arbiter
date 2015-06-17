#!/bin/bash -x
set -e

export RAILS_ENV=test

git clean -fdx
bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment
bundle exec rake remove_default_column_limit db:drop db:create db:schema:load
bundle exec rake
