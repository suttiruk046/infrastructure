#!/bin/bash

set -eu

echo "INFO Run syntax checks for shell scripts"
for file in gocd/scripts/pipeline/*; do
  bash -n $file
done
