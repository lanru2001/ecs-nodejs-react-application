# Set shell
SHELL := /bin/bash

# Set environment directory path from user-passed ENV variable
FOLDER := "environments/${ENV}"

# Check to make sure that ENV variable was passed and environments folder exists
.PHONY: checkenv
checkenv:
	@echo "[INFO]: Checking environment...";\
	if [ -z "${ENV}" ]; then\
		echo "[ERROR]: Environment not set";\
		exit 10;\
	fi;\
	if [ ! -d "${FOLDER}" ]; then\
		echo "[ERROR] environments folder does not exist";\
		exit 10;\
	fi;\

.PHONY: init
init: checkenv
	@pushd ./"${FOLDER}" > /dev/null;\
	echo "[INFO]: Performing terraform init";\
	terraform init -reconfigure;\
	if [ ! $$? -eq 0 ]; then\
		echo "[ERROR] Command failed";\
		exit 13;\
	fi;\
	popd > /dev/null;\
	echo "Done!"

.PHONY: plan
plan: init
	@pushd ./"${FOLDER}" > /dev/null;\
	echo "[INFO]: Performing terraform plan";\
	terraform plan -refresh=true;\
	popd > /dev/null;\
	echo "Done!"


.PHONY: apply
apply: init
	@pushd "${FOLDER}" > /dev/null;\
	echo "[INFO]: Performing terraform apply...";\
	terraform apply -refresh=true;\
	popd > /dev/null;\
	echo "Done!"

.PHONY: fmt
fmt:
	@echo "Performing terraform fmt recursively.";\
	terraform fmt -recursive;\
	echo "Done!"

.PHONY: destroy
destroy: init
	@pushd "${FOLDER}" > /dev/null;\
	echo "[INFO]: Performing terraform destroy...";\
	terraform destroy -refresh=true;\
	popd > /dev/null;\
	echo "Done!"
