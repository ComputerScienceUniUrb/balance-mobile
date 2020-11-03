#!/bin/bash

sudo apt update
# This script will install sqlite3 in the machine.
# It's usefull when the repository is tested in a
# remote CI system.
sudo apt-get -y install sqlite3 libsqlite3-dev