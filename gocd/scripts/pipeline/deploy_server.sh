#!/bin/bash

set -eu

for resource in $(oc get build | grep gocd-server | grep -o '^\S\+'); do oc delete build $resource; done

oc start-build bc/gocd-server \
               --follow \
               --namespace=${oc_namespace}

oc rollout latest dc/gocd-server --namespace=${oc_namespace} && \
oc logs -f dc/gocd-server --namespace=${oc_namespace}
oc rollout status dc/gocd-server --namespace=${oc_namespace}
