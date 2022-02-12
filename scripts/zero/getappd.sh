#!/bin/bash


function parse_input() {
  # jq reads from stdin so we don't have to set up any inputs, but let's validate the outputs
  eval "$(jq -r '@sh "export APP_NAME=\(.appname)  URL=\(.url) ACC_KEY=\(.accesskey) CLIENT_SECRET=\(.clientsecret) CLIENT_ID=\(.clientid) JVER=\(.jver)"')"
  if [[ -z "${APP_NAME}" ]]; then export APP_NAME=none; fi
  if [[ -z "${ACC_KEY}" ]]; then export ACC_KEY=none; fi
  if [[ -z "${JVER}" ]]; then export JVER=none; fi
  if [[ -z "${URL}" ]]; then export URL=none; fi
  if [[ -z "${CLIENT_ID}" ]]; then export CLIENT_ID=none; fi
  if [[ -z "${CLIENT_SECRET}" ]]; then export CLIENT_SECRET=none; fi
}

parse_input

content=$(curl -s --location --request POST "${URL}/auth/v1/oauth/token" --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'grant_type=client_credentials' --data-urlencode "client_id=${CLIENT_ID}" --data-urlencode "client_secret=${CLIENT_SECRET}" | jq '.access_token') 

temp="${content%\"}"
temp="${temp#\"}"

download="$(curl -s --location --request GET "${URL}/zero/v1beta/install/downloadCommand?javaVersion=${JVER}&machineVersion=latest&infraVersion=latest&zeroVersion=latest&multiline=false" \
--header "Authorization: Bearer ${temp}" --data-raw '')"

install="$(curl -s --location --request GET "${URL}/zero/v1beta/install/installCommand?sudo=true&multiline=false&application=${APP_NAME}&accessKey=fillmein&serviceUrl=${URL}" \
--header "Authorization: Bearer ${temp}" --data-raw '')"


echo -n "{\"download\":${download}, \"install\":${install}}" | tr -d ']['
#END
