#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

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

#Create configuration
# Step 1: Base64 encode the zip file

base64_encoded_zip=$(base64 -i ocp-deployment/datasources.json.zip)

# Step 2: Create the secret YAML file
cat <<EOF > secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mongo-datasource-ace-config-secret
type: Opaque
data:
  configuration: $base64_encoded_zip
EOF

# Step 3: Apply the secret
oc apply -f secret.yaml

oc apply -f ocp-deployment/mongo-datasource-ace-config.yaml

#Build and push docker image
ibm_registry_username="$(oc get secrets ibm-entitlement-key -o json | jq -r '.data[".dockerconfigjson"]' | base64 -d | jq -r '.auths["cp.icr.io"].username')"
ibm_registry_password="$(oc get secrets ibm-entitlement-key -o json | jq -r '.data[".dockerconfigjson"]' | base64 -d | jq -r '.auths["cp.icr.io"].password')"
podman login cp.icr.io -u "$ibm_registry_username" -p "$ibm_registry_password"
podman login "$HOST" -u "$(oc whoami)" -p "$(oc whoami -t)"

podman build -t ace-read-customer-details get-customer-image --platform=linux/amd64
echo "Build Succeeded"

podman tag ace-read-customer-details "$HOST"/"$PROJECT_NAME"/ace-read-customer-details:2.0
echo "Tag Succeeded"

podman push "$HOST"/"$PROJECT_NAME"/ace-read-customer-details:2.0 --tls-verify=false
echo "ACE image has been pushed to OpenShift registry."

# Deploy ACE using the YAML file
echo "Deploying ACE..."
oc apply -f ocp-deployment/ace-read-customer-details.yaml

echo "Sending test request"
curl --request GET \
  --url http://get-customer-details-http-ace.apps.66311da33313fb001ef59e09.cloud.techzone.ibm.com/customerdetailretriever/v1/customers/123 \
  --header 'accept: application/json'

echo "Successfuly send test request"