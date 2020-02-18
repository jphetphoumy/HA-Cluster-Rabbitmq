.PHONY: all build deploy create rabbit plan apply destroy
all: plan

DO_TOKEN?=digital_token

build:
	cd packer-heartbeat && \
	packer build \
          packer.json

deploy: apply create

apply:
	cd terraform && \
	terraform apply \
                -var-file="secret.tfvars" \
		-auto-approve
create:
	cd ansible && \
	ansible-playbook playbooks.yml -i hosts -b -u  root -e do_token=${DO_TOKEN}

rabbit:
	cd ansible && \
	ansible-playbook rabbitmq.yml -i hosts -b -u  root

destroy:
	cd terraform && \
	terraform destroy \
		-var-file="secret.tfvars" \
		-auto-approve
