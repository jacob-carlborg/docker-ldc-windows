#!/bin/bash

set -eu

docker build -t ldc-windows "$@" .
