#!/bin/bash

set -eu

oc start-build bc/gocd-server \
               --follow \
               --namespace=${oc_namespace}

oc rollout latest dc/gocd-server --namespace=${oc_namespace} && \
oc logs -f dc/gocd-server --namespace=${oc_namespace}
oc rollout status dc/gocd-server --namespace=${oc_namespace}
