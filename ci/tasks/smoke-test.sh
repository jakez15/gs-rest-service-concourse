#!/bin/bash

set -e -x

pushd source-repo
	echo "0"
	curl 'https://gs-rest-service-concourse.cfapps.io/health'
	echo "1"
	curl 'https://gs-rest-service-concourse.cfapps.io/health' | jq '.status == "UP"'
	echo "2"
	HEALTH=$(curl 'https://gs-rest-service-concourse.cfapps.io/health' | jq '.status == "UP"')
	
	echo $HEALTH
	
	if [[ true == $HEALTH ]]; then
		echo "PASSED Smoke Tests"
	else 
		echo "FAILED Smoke Tests"
		return 1
	fi 	
popd