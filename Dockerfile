FROM hashicorp/terraform:1.1.4

RUN adduser -D TERRAFORM

USER TERRAFORM