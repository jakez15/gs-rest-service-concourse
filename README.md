## Spring Guides + Concourse + PCF  Tuturial

## Learning Resources
- https://www.pivotalk.io/t/concourse-courses-episodes/2434
- https://github.com/starkandwayne/concourse-tutorial
- http://cloud.spring.io/spring-cloud-pipelines/

## Prerequisites
1. VirtualBox: [Install Instructions](https://www.virtualbox.org/wiki/Downloads)
1. Concourse Docker: [Install Instructions](http://concourse.ci/docker-repository.html)
1. Fly CLI: [Install Instructions](http://concourse.ci/hello-world.html)
1. PCF DEV: [Install Instructions](https://docs.pivotal.io/pcf-dev/#installing)
1. GitHub account 


## Import Building a RESTful Web Service 
1. Import the gs-rest-service-complete project
	- [Use STS IDE](https://spring.io/guides/gs/rest-service/#use-sts)
	- [Use IntelliJ IDEA](https://spring.io/guides/gs/intellij-idea) 
1. Maven will be used so you can safely delete `gradle` related files 
1. Update manifest.yml file to:

	```
	---
	applications:
	- name: gs-rest-service-complete
	  memory: 256M
	  instances: 1
	  buildpack: java_buildpack
	```
1. Create a GitHub repository: [Create GitHub Repository Instructions](https://help.github.com/articles/creating-a-new-repository/)

1. Init, add, commit, remote, and push code to Repo
	```
	echo "# gs-rest-service-complete" >> README.md
	git init
	git add README.md
	git commit -m "first commit"
	git remote add origin https://github.com/<ADD GITHUB ACCT>/gs-rest-service-complete.git
	git push -u origin master
	```

1. Create a `ci` folder under the root project directory

1. Create a `tasks` folder under `ci` 

1. Create `ci/pipeline.yml` and update GitHub uri with your GitHub account

	  ```
	  ---
	  resources:
	    - name: source-code
	      type: git
	      source:
		uri: https://github.com/jzingler/gs-rest-service-concourse.git
		branch: master  
	    - name: cf-push-packaged-app
	      type: cf
	      source:
	        api: {{cf_api}}
	        organization: {{cf_org}}
	        space: {{cf_space}}
	        username: {{cf_username}}
	        password: {{cf_password}}
	        skip_cert_check: false

	  jobs:
	    - name: package
	      plan:
	      - get: source-code
		trigger: true
	      - task: package
		privileged: true
		file: source-code/ci/tasks/package.yml
	      - put: cf-push-packaged-app
		params:
		  manifest: build-output/manifest.yml
	  ```

1. Create `ci/pipeline_params_template.yml` file and input cf info:
	
	**DO NOT COMMIT CREDENTIALS TO REPO**
	
	```
	cf_api: <enter cf api>
	cf_org: <enter cf org>
	cf_space: <enter cf space>
	cf_username: <enter username>
	cf_password: <enter password>
	```

1. Create `ci/tasks/package.yml`
	
	  ```
	  ---
	  platform: linux

	  image_resource:
	    type: docker-image
	    source: 
	      repository: maven   

	  inputs:
	    - name: source-code

	  outputs:
	    - name: build-output

	  caches:
	    - path: .m2/repository

	  run:
	    path: /bin/bash
	    args:
	      - source-code/ci/tasks/package.sh
	  ```


1. Create `ci/tasks/package.sh` file

	```
	#!/bin/bash

	set -e -x

	pushd source-code
		mvn -Dmaven.repo.local=../.m2/repository clean package

		cp manifest.yml  ../build-output/.
		cp target/gs-rest-service-concourse-0.1.0.jar  ../build-output/.
	popd

	```

1. Directory structure after adding above folders and files

	```
	.
	├── README.md
	├── ci
	│   ├── pipeline.yml
	│   ├── pipeline_params_template.yml
	│   └── tasks
	│       ├── package.sh
	│       └── package.yml
	├── manifest.yml
	├── mvnw
	├── mvnw.cmd
	├── pom.xml
	└── src
	    ├── main
	    │   └── java
	    │       └── hello
	    │           ├── Application.java
	    │           ├── Greeting.java
	    │           └── GreetingController.java
	    └── test
	        └── java
	            └── hello
	                └── GreetingControllerTests.java
	```

1. Stage, commit, and push updates: 
	- `git add . && git commit -am "create ci pipeline files" && git push`

1. Login to concourse via FLY: 
	- `fly -t s3-version login -c http://127.0.0.1:8080/` 

1. Set the pipeline up with the following fly command:

	- `fly -t s3-version set-pipeline -p gs-rest-service-concourse -c ci/pipeline.yml --non-interactive --load-vars-from ci/pipeline_params_template.yml`

1. Unpause the pipeline with the following fly command:

	- `fly -t s3-version unpause-pipeline -p gs-rest-service-concourse`
 
1. Validate that the concourse package and cf push jobs completed successfully

