#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Deploy MQ using the YAML file
echo "Deploying MQ..."
oc apply -f ocp-deployment/configmap.yaml
oc apply -f ocp-deployment/mq.yaml