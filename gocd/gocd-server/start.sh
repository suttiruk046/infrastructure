#!/bin/bash
set -e

export CONFIG_FOLDER=/var/lib/go-server/config

# Install plugins
mkdir -p /var/lib/go-server/plugins/external/
wget --no-clobber https://github.com/gocd-contrib/script-executor-task/releases/download/0.3/script-executor-0.3.0.jar \
     --output-document=/var/lib/go-server/plugins/external/script-executor-plugin.jar || true

wget --no-clobber https://github.com/gocd-contrib/gocd_auth_plugin_guest_user/releases/download/v0.2/gocd_auth_plugin_guest_user-1.0.jar \
     --output-document=/var/lib/go-server/plugins/external/gocd_auth_plugin_guest_user-plugin.jar || true

# Start service
java $JAVA_OPTS -jar /usr/share/go-server/go.jar &
pid=$!

until curl -s -o /dev/null 'http://localhost:8153'
do
  printf '.'
  sleep 1
done

# INFO Store access tokens during deploy time
# We get access token from `oc secret` during deploy time and store it
# @see https://git-scm.com/book/gr/v2/Git-Tools-Credential-Storage
if [[ -n $GOCD_GITHUB_USERNAME || -n $GOCD_GITHUB_ACCESS_TOKEN ]]; then
  git config --global credential.helper "store --file ${CONFIG_FOLDER}/.git-credentials"
  cat <<EOF > ${CONFIG_FOLDER}/.git-credentials
https://${GOCD_GITHUB_USERNAME}:${GOCD_GITHUB_ACCESS_TOKEN}@github.axa.com
EOF
fi

# Override values with ENV variables
if [ -n "$GOCD_AGENT_SECRET" ]
then
  sed -i -e 's/agentAutoRegisterKey="[^"]*" *//' -e 's#\(<server\)\(.*artifactsdir.*\)#\1 agentAutoRegisterKey="'$GOCD_AGENT_SECRET'"\2#' ${CONFIG_FOLDER}/cruise-config.xml
fi

wait $pid
