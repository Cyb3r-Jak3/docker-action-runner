#!/bin/bash

runner_name=${RUNNER_NAME-$(hostname)}

echo "Configuring runner @ ${RUNNER_SCOPE}"

function fatal()
{
   echo "error: $1" >&2
   exit 1
}


if [ -z "${RUNNER_SCOPE}" ]; then fatal "supply scope as env"; fi
if [ -z "${RUNNER_CFG_PAT}" ]  && [ -z "${RUNNER_TOKEN}" ]; then fatal "RUNNER_CFG_PAT or RUNNER_TOKEN must be set before calling"; fi

#--------------------------------------
# Get a config token
#--------------------------------------

if [ -n "${RUNNER_CFG_PAT}" ]; then
    echo
    echo "Generating a registration token..."
    base_api_url="https://api.github.com"
    if [ -n "${ghe_hostname}" ]; then
        base_api_url="https://${ghe_hostname}/api/v3"
    fi

    # if the scope has a slash, it's a repo runner
    orgs_or_repos="orgs"
    if [[ "$RUNNER_SCOPE" == *\/* ]]; then
        orgs_or_repos="repos"
    fi

    RUNNER_TOKEN=$(curl -s -X POST ${base_api_url}/${orgs_or_repos}/${RUNNER_SCOPE}/actions/runners/registration-token -H "accept: application/vnd.github.everest-preview+json" -H "authorization: token ${RUNNER_CFG_PAT}" | jq -r '.token')

    if [ "null" == "$RUNNER_TOKEN" ] || [ -z "$RUNNER_TOKEN" ]; then fatal "Failed to get a token"; fi
fi

#---------------------------------------
# Unattend config
#---------------------------------------
runner_url="https://github.com/${RUNNER_SCOPE}"
if [ -n "${GHE_HOSTNAME}" ]; then
    runner_url="https://${GHE_HOSTNAME}/${RUNNER_SCOPE}"
fi
cd /runner || exit
echo
echo "Configuring ${runner_name} @ $runner_url"
echo "config.sh --unattended --url $runner_url --token *** --name $runner_name --labels $LABELS"
./config.sh --unattended --url $runner_url --token $RUNNER_TOKEN --name $runner_name --labels $LABELS

