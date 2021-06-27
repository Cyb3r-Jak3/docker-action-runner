#!/bin/bash

#---------------------------------------
# Validate Environment
#---------------------------------------
runner_plat=linux
[ -n "$(which sw_vers)" ] && runner_plat=osx;

#---------------------------------------
# Download latest released and extract
#---------------------------------------
mkdir /runner
echo
echo "Downloading latest runner ..."

# For the GHES Alpha, download the runner from github.com
latest_version_label=$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.tag_name')
latest_version=$(echo ${latest_version_label:1})
runner_file="actions-runner-${runner_plat}-x64-${latest_version}.tar.gz"

if [ -f "${runner_file}" ]; then
    echo "${runner_file} exists. skipping download."
else
    runner_url="https://github.com/actions/runner/releases/download/${latest_version_label}/${runner_file}"

    echo "Downloading ${latest_version_label} for ${runner_plat} ..."
    echo $runner_url

    curl -O -L ${runner_url}
fi

#---------------------------------------------------
# extract to runner directory in this directory
#---------------------------------------------------
echo
echo "Extracting ${runner_file} to /runner"

tar xzf "./${runner_file}" -C /runner

pushd /runner || exit

/runner/bin/installdependencies.sh

echo "Installed"