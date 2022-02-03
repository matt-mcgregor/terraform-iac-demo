.PHONY: test build deploy destroy build_image publish_image

ifdef OS
  export USER_ID=1001
  export GROUP_ID=1001
else
  export USER_ID=$(shell id -u)
  export GROUP_ID=$(shell id -g)
endif

export IMAGE_NAME = codemonkey247/terraform-iac-demo
export IMAGE_TAG = latest

RUN_TERRAFORM = docker-compose run --rm terraform
TF_PLAN_NAME = terraform-iac-demo.plan
REGION = eu-west-2

## Docker build and publish Terraform utils image

build_image:
	docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

publish_image:
	docker push ${IMAGE_NAME}:${IMAGE_TAG}

## Terraform targets for deployment to AWS

test:
	${RUN_TERRAFORM} init -input=false
	${RUN_TERRAFORM} validate

build:
	${RUN_TERRAFORM} plan -var region=${REGION} -var-file=config/${REGION}.tfvars -out ${TF_PLAN_NAME}

deploy:
	${RUN_TERRAFORM} apply ${TF_PLAN_NAME}

destroy:
	${RUN_TERRAFORM} destroy -input=false -auto-approve -var region=${REGION} -var-file=config/${REGION}.tfvars
