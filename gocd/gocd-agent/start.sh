#!/bin/bash
set -e

export CONFIG_FOLDER=/usr/share/go-agent/config

mkdir -p $CONFIG_FOLDER

# INFO Store access tokens during deploy time
# We get access token from `oc secret` during deploy time and store it
# @see https://git-scm.com/book/gr/v2/Git-Tools-Credential-Storage
if [[ -n $GOCD_GITHUB_USERNAME || -n $GOCD_GITHUB_ACCESS_TOKEN ]]; then
  git config --global credential.helper "store --file ${CONFIG_FOLDER}/.git-credentials"
  cat <<EOF > ${CONFIG_FOLDER}/.git-credentials
https://${GOCD_GITHUB_USERNAME}:${GOCD_GITHUB_ACCESS_TOKEN}@github.axa.com
EOF
fi

echo "INFO set autoregister.properties"
cat <<EOF > ${CONFIG_FOLDER}/autoregister.properties
agent.auto.register.key=${GOCD_AGENT_SECRET}
agent.auto.register.resources=${GOCD_AGENT_AUTO_REGISTER_RESOURCES}
agent.auto.register.environments=${GOCD_AGENT_AUTO_REGISTER_ENVIRONMENTS}
agent.auto.register.hostname=`hostname -f`
EOF

/usr/share/go-agent/agent.sh
