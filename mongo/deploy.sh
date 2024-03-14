#!/bin/bash

HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
if ! podman login -u kubeadmin -p "$(oc whoami -t)" --tls-verify=false $HOST; then
    echo "Failed to login to the registry. Exiting."
    exit 1
fi

# Define the project name
PROJECT_NAME="mongodb"
if oc get project "$PROJECT_NAME" &>/dev/null; then
    echo "Project '$PROJECT_NAME' already exists."
else
    # Create the project if it doesn't exist
    oc new-project "$PROJECT_NAME"
    echo "Project '$PROJECT_NAME' created."
fi

#Build and push docker image
podman build -t mongodb mongodb-custom-image
echo "Build Succeeded"

podman tag mongodb "$HOST"/"$PROJECT_NAME"/mongodb
echo "Tag Succeeded"

podman push "$HOST"/"$PROJECT_NAME"/mongodb --tls-verify=false
echo "MongoDB image has been pushed to OpenShift registry."


# Deploy MongoDB using the YAML file
echo "Deploying MongoDB..."
oc apply -f ocp/mongodb.yaml

# Wait for MongoDB StatefulSet to be ready
echo "Waiting for MongoDB to be ready..."
oc rollout status statefulset/mongodb
