#!/bin/bash

set -eu

for resource in $(oc get build | grep gocd-agent | grep -o '^\S\+'); do oc delete build $resource; done

oc start-build bc/gocd-agent \
               --follow \
               --namespace=${oc_namespace}

oc rollout latest dc/gocd-agent --namespace=${oc_namespace} && \
oc logs -f dc/gocd-agent --namespace=${oc_namespace}
oc rollout status dc/gocd-agent --namespace=${oc_namespace}
