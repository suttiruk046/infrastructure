#!/bin/bash

set -eu

oc apply --dry-run=true \
         --recursive=true \
         --filename=gocd/openshift \
         --namespace=${oc_namespace}
