#!/bin/bash

set -eu

# Cleanup old builds (in case the build hangs)
oc delete --namespace=${oc_namespace} --cascade=true bc/gocd-server || true

oc replace --namespace=${oc_namespace} -f gocd/openshift/common/configmap-infrastructure-gocd.yaml

oc replace --force --namespace=${oc_namespace} -f gocd/openshift/agent/buildconfig-infrastructure-gocd-agent.yaml
oc replace --namespace=${oc_namespace} -f gocd/openshift/agent/deploymentconfig-infrastructure-gocd-agent.yaml
oc replace --namespace=${oc_namespace} -f gocd/openshift/agent/horizontalpodautoscaler-infrastructure-gocd-agent.yaml
oc replace --namespace=${oc_namespace} -f gocd/openshift/agent/imagestream-infrastructure-gocd-agent.yaml

oc replace --force --namespace=${oc_namespace} -f gocd/openshift/server/buildconfig-infrastructure-gocd-server.yaml
oc replace --namespace=${oc_namespace} -f gocd/openshift/server/deploymentconfig-infrastructure-gocd-server.yaml
oc replace --namespace=${oc_namespace} -f gocd/openshift/server/imagestream-infrastructure-gocd-server.yaml
oc create  --namespace=${oc_namespace} -f gocd/openshift/server/persistentvolumeclaim-infrastructure-gocd-server.yaml || true
oc replace --namespace=${oc_namespace} -f gocd/openshift/server/route-infrastructure-gocd-server.yaml
oc apply --namespace=${oc_namespace} -f gocd/openshift/server/service-infrastructure-gocd-server.yaml
