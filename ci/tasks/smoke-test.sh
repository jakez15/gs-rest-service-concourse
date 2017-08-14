#!/bin/bash

set -e -x

pushd source-repo
    HEALTH=$(curl https://gs-rest-service-concourse.cfapps.io/health | jq '.status == "UP"')
	if [[ true == $HEALTH ]]; then
		echo "PASSED Smoke Tests"
	else 
		echo "FAILED Smoke Tests"
	fi 	
popd