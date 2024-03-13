#Patch the image registry and get the route
oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge
HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
if ! podman login -u kubeadmin -p "$(oc whoami -t)" --tls-verify=false $HOST; then
    echo "Failed to login to the registry. Exiting."
    exit 1
fi

# Check if the project exists
PROJECT_NAME=ocp-example
if oc get project "$PROJECT_NAME" &>/dev/null; then
    echo "Project '$PROJECT_NAME' already exists."
else
    # Create the project if it doesn't exist
    oc new-project "$PROJECT_NAME"
    echo "Project '$PROJECT_NAME' created."
fi

#Build and push docker image
podman build -t flask-app app
echo "Build Succeeded"

podman tag flask-app "$HOST"/"$PROJECT_NAME"/flask-app
echo "Tag Succeeded"

podman push "$HOST"/"$PROJECT_NAME"/flask-app --tls-verify=false
echo "Push Succeeded"

#Create configurations
oc create configmap flask-config --from-literal=APP_ENV=production
oc create secret generic flask-secret --from-literal=DB_PASSWORD=mysecretpassword

#Deploy project
#Replace project name in deployment yaml
TMP_FILE=$(mktemp)
awk -v project="$PROJECT_NAME" '{gsub(/\$PROJECT/, project)}1' ocp/deployment.yaml > "$TMP_FILE"
oc apply -f "$TMP_FILE"

oc apply -f ocp/service.yaml

if oc get project "$PROJECT_NAME" &>/dev/null; then
    echo "Project '$PROJECT_NAME' already exists."
else
    # Create the project if it doesn't exist
    oc new-project "$PROJECT_NAME"
    echo "Project '$PROJECT_NAME' created."
fi

oc expose service flask-service
oc get route flask-service --template='{{ .spec.host }}'


