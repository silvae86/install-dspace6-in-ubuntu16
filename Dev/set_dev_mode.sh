#!/usr/bin/env bash

brew install postgresql
brew services start postgresql
createdb dspace
psql
#CREATE EXTENSION pgcrypto;
# \q to quit
