#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

./prepare_and_upload_configurations.sh

HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
if ! podman login -u kubeadmin -p "$(oc whoami -t)" --tls-verify=false $HOST; then
    echo "Failed to login to the registry. Exiting."
    exit 1
fi

# Define the project name
PROJECT_NAME="ace"
if oc get project "$PROJECT_NAME" &>/dev/null; then
    oc project "$PROJECT_NAME"
    echo "Project '$PROJECT_NAME' already exists."
else
    # Create the project if it doesn't exist
    oc new-project "$PROJECT_NAME"
    echo "Project '$PROJECT_NAME' created."
fi

#Build and push docker image
ibm_registry_username="$(oc get secrets ibm-entitlement-key -o json | jq -r '.data[".dockerconfigjson"]' | base64 -d | jq -r '.auths["cp.icr.io"].username')"
ibm_registry_password="$(oc get secrets ibm-entitlement-key -o json | jq -r '.data[".dockerconfigjson"]' | base64 -d | jq -r '.auths["cp.icr.io"].password')"
podman login cp.icr.io -u "$ibm_registry_username" -p "$ibm_registry_password"
podman login "$HOST" -u "$(oc whoami)" -p "$(oc whoami -t)"

podman build -t ace-mq-test ace-mq-image --platform=linux/amd64
echo "Build Succeeded"

podman tag ace-mq-test "$HOST"/"$PROJECT_NAME"/ace-mq-test:1.0
echo "Tag Succeeded"

podman push "$HOST"/"$PROJECT_NAME"/ace-mq-test:1.0 --tls-verify=false
echo "ACE image has been pushed to OpenShift registry."

# Deploy ACE using the YAML file
echo "Deploying ACE..."
oc apply -f ocp-deployment/ace-mq-test.yaml
