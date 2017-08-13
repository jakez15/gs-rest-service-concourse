#!/bin/bash

VERSION=`cat version/number`

echo "Version resource is [${VERSION}]"

set -e -x

pushd source-repo
	mvn versions:set -DnewVersion=${VERSION} -Dmaven.repo.local=../.m2/repository
	mvn clean package -Dmaven.repo.local=../.m2/repository -DskipTests=true
	
	cp pom.xml ../build-output/pom-${VERSION}.xml
	cp manifest.yml  ../build-output/manifest-${VERSION}.yml
	cp target/gs-rest-service-concourse-${VERSION}.jar  ../build-output/.
popd

