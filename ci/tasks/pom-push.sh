#!/bin/bash

set -e -x

pushd minio-s3-bucket-pom

	git clone https://github.com/jzingler/gs-rest-service-concourse.git source-repo-update-pom
	
	cd source-repo-update-pom
	
	mv ../pom-*.xml pom.xml
	
	git add pom.xml
	
	git commit pom.xml -m "update pom project version"
popd

