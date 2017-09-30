#!/bin/bash

set -eu

oc start-build bc/gocd-agent \
               --follow \
               --namespace=${oc_namespace}

oc rollout latest dc/gocd-agent --namespace=${oc_namespace} && \
oc logs -f dc/gocd-agent --namespace=${oc_namespace}
oc rollout status dc/gocd-agent --namespace=${oc_namespace}
