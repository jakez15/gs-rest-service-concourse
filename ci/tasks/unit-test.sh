#!/bin/bash

set -e -x

pushd source-repo
	mvn clean test -Dmaven.repo.local=../.m2/repository	
popd
