#!/bin/bash

set -e

REALM=interservice_auth
CLIENT=client
CLIENT_SECRET=9lpm7v9PhgQDO8j3IOXqSIkI02BpZOxF
GRANT_TYPE=client_credentials

echo "----------------------------------------------------------------------------------------"
printf "#1 Direct request to the server\n"
curl -v -s http://ggk_server:8080/
echo ""
read -n 1 -s -r -p "Press any key to continue"
echo ""

echo "----------------------------------------------------------------------------------------"
printf "\n\n#2 Request to the server via gogatekeeper WITHOUT token\n"
curl -v -s http://ggk_ggk:8080/
echo ""
read -n 1 -s -r -p "Press any key to continue"
echo ""

echo "----------------------------------------------------------------------------------------"
printf "\n\n#3 Fetch token from keycloak\n"
TOKEN=$(curl -s "http://ggk_keycloak:8080/auth/realms/${REALM}/protocol/openid-connect/token" -d "grant_type=${GRANT_TYPE}&client_id=${CLIENT}&client_secret=${CLIENT_SECRET}" | jq --raw-output ".access_token")
jq -R 'split(".") | .[1] | @base64d | fromjson' <<< "$TOKEN"
echo ""
read -n 1 -s -r -p "Press any key to continue"
echo ""

echo "----------------------------------------------------------------------------------------"
printf "\n\n#4 Request to the server via gogatekeeper WITH token\n"
curl -v -s http://ggk_ggk:8080/ -H "Authorization: Bearer $TOKEN"
