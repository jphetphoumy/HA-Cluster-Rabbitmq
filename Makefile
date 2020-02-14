.PHONY: all build deploy create plan apply destroy
all: plan

DO_TOKEN?=digital_token

build:
	cd packer-hearbeat && \
	packer build -var do_token=${DO_TOKEN} packer.json

deploy: apply create

apply:
	cd terraform && \
	terraform apply \
		-var do_token=${DO_TOKEN} \
		-var private_key=/home/jeremy/.ssh/id_rsa \
		-var ssh_fingerprint=59:34:2f:e2:54:97:e9:5c:f9:fe:47:1d:ff:cb:f6:14 \
		-var public_key=/home/jeremy/.ssh/id_rsa.pub \
		-auto-approve
create:
	cd ansible && \
	ansible-playbook playbooks.yml -i hosts -b -u  root -e do_token=${DO_TOKEN}


destroy:
	cd terraform && \
	terraform destroy \
		-var do_token=${DO_TOKEN} \
		-var private_key=/home/jeremy/.ssh/id_rsa \
		-var ssh_fingerprint=59:34:2f:e2:54:97:e9:5c:f9:fe:47:1d:ff:cb:f6:14 \
		-var public_key=/home/jeremy/.ssh/id_rsa.pub \
		-auto-approve
