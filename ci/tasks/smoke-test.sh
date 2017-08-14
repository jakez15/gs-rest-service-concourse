#!/bin/bash

set -e -x

pushd source-repo
    
	if [[ true == $(curl https://gs-rest-service-concourse.cfapps.io/health | jq '.status == "UP"') ]]; then
		echo "PASSED Smoke Tests"
	else 
		echo "FAILED Smoke Tests"
	fi 	
popd