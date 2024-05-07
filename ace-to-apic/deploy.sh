oc project apic

USERNAME="ENTER ME"
PASSWORD="ENTER ME"

mgmt_json_config=$(oc get ManagementCluster apic-mgmt -n apic -o json | jq -r '.status.endpoints[] | select(.name=="platformApi")')

# Extract the values
PLATFORM_API_SECRET_NAME=$(echo "$mgmt_json_config" | grep -o '"secretName": "[^"]*' | awk -F'"' '{print $4}')
PLATFORM_API_URI=$(echo "$mgmt_json_config" | grep -o '"uri": "[^"]*' | awk -F'"' '{print $4}')

# Retrieve the ca.crt data from the existing secret
CERT_DATA=$(oc get secret "$PLATFORM_API_SECRET_NAME" -o json | jq -r '.data["ca.crt"]')

# Base64 decode the certificate data
DECODED_CERT=$(echo "$CERT_DATA" | base64 --decode)

# Create a new secret with the decoded certificate data
echo "
apiVersion: v1
kind: Secret
metadata:
  name: apim-credentials
  namespace: ace
type: Opaque
data:
  base_url: $(echo "$PLATFORM_API_URI" | base64)
  username: $(echo "$USERNAME" | base64)
  password: $(echo "$PASSWORD" | base64)
  trusted_cert: $(echo "$DECODED_CERT" | base64)
" | oc apply -f -

oc apply -f get-customer-details-api.yaml
oc apply -f get-customer-details-product.yaml