#!/bin/bash

# Define the project name
PROJECT_NAME="mongodb"

#!/bin/bash

# Define variables
LOCAL_IMAGE="mongo:latest"
OPENSHIFT_IMAGE="openshift-registry.example.com/myproject/mongo:latest"  # Replace with your OpenShift registry URL and project name
OPENSHIFT_REGISTRY=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
OPENSHIFT_IMAGE="$OPENSHIFT_REGISTRY/$PROJECT_NAME/mongo:latest"

# Pull the MongoDB image locally
echo "Pulling MongoDB image locally..."
podman pull $LOCAL_IMAGE --platform=linux/amd64


# Tag the local MongoDB image for OpenShift registry
echo "Tagging MongoDB image for OpenShift registry..."
podman tag $LOCAL_IMAGE $OPENSHIFT_IMAGE

# Push the MongoDB image to OpenShift registry
echo "Pushing MongoDB image to OpenShift registry..."
podman push $OPENSHIFT_IMAGE --tls-verify=false

echo "MongoDB image has been pushed to OpenShift registry."

# Create a new project
echo "Creating project $PROJECT_NAME..."
oc new-project $PROJECT_NAME

# Deploy MongoDB using the YAML file
echo "Deploying MongoDB..."
oc apply -f mongo/mongodb.yaml

# Wait for MongoDB StatefulSet to be ready
echo "Waiting for MongoDB to be ready..."
oc rollout status statefulset/mongodb


# Retrieve MongoDB database admin password
echo "Retrieving MongoDB database admin password..."
MONGODB_ADMIN_PASSWORD=$(oc get secrets mongodb -o=jsonpath="{.data['database-admin-password']}" | base64 -d)
echo "MongoDB database admin password: $MONGODB_ADMIN_PASSWORD"

# Retrieve MongoDB database name
echo "Retrieving MongoDB database name..."
MONGODB_DATABASE_NAME=$(oc get secrets mongodb -o=jsonpath='{.data.database-name}' | base64 -d)
echo "MongoDB database name: $MONGODB_DATABASE_NAME"

# Retrieve MongoDB database password
echo "Retrieving MongoDB database password..."
MONGODB_DATABASE_PASSWORD=$(oc get secrets mongodb -o=jsonpath='{.data.database-password}' | base64 -d)
echo "MongoDB database password: $MONGODB_DATABASE_PASSWORD"

# Retrieve MongoDB database user
echo "Retrieving MongoDB database user..."
MONGODB_DATABASE_USER=$(oc get secrets mongodb -o=jsonpath='{.data.database-user}' | base64 -d)
echo "MongoDB database user: $MONGODB_DATABASE_USER"
