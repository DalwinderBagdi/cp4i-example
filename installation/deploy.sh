
oc new-project cp4i
oc new-project ace
oc new-project mq
oc new-project apic
oc new-project ibm-common-services
oc new-project cert-manager-operator

oc create secret docker-registry ibm-entitlement-key --docker-username=cp --docker-password=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2NjY4NjQxMDIsImp0aSI6IjZhOTZhZTFjOTA1MTQ1NjA4ZTU1ZWI2Y2NhYjRkY2QxIn0.8_pQ6MfNvd6mBWUQ6xMzP1g3QBYAZPlbs_lgO74kFcw --docker-server=cp.icr.io --namespace=cp4i

oc create secret docker-registry ibm-entitlement-key --docker-username=cp --docker-password=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2NjY4NjQxMDIsImp0aSI6IjZhOTZhZTFjOTA1MTQ1NjA4ZTU1ZWI2Y2NhYjRkY2QxIn0.8_pQ6MfNvd6mBWUQ6xMzP1g3QBYAZPlbs_lgO74kFcw --docker-server=cp.icr.io --namespace=ace

oc create secret docker-registry ibm-entitlement-key --docker-username=cp --docker-password=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2NjY4NjQxMDIsImp0aSI6IjZhOTZhZTFjOTA1MTQ1NjA4ZTU1ZWI2Y2NhYjRkY2QxIn0.8_pQ6MfNvd6mBWUQ6xMzP1g3QBYAZPlbs_lgO74kFcw --docker-server=cp.icr.io --namespace=mq

oc create secret docker-registry ibm-entitlement-key --docker-username=cp --docker-password=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2NjY4NjQxMDIsImp0aSI6IjZhOTZhZTFjOTA1MTQ1NjA4ZTU1ZWI2Y2NhYjRkY2QxIn0.8_pQ6MfNvd6mBWUQ6xMzP1g3QBYAZPlbs_lgO74kFcw --docker-server=cp.icr.io --namespace=apic

oc create secret docker-registry ibm-entitlement-key --docker-username=cp --docker-password=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2NjY4NjQxMDIsImp0aSI6IjZhOTZhZTFjOTA1MTQ1NjA4ZTU1ZWI2Y2NhYjRkY2QxIn0.8_pQ6MfNvd6mBWUQ6xMzP1g3QBYAZPlbs_lgO74kFcw --docker-server=cp.icr.io --namespace=ibm-common-services

oc create secret docker-registry ibm-entitlement-key --docker-username=cp --docker-password=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2NjY4NjQxMDIsImp0aSI6IjZhOTZhZTFjOTA1MTQ1NjA4ZTU1ZWI2Y2NhYjRkY2QxIn0.8_pQ6MfNvd6mBWUQ6xMzP1g3QBYAZPlbs_lgO74kFcw --docker-server=cp.icr.io --namespace=openshift-operators

cat << EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-integration-platform-navigator-catalog
  namespace: openshift-marketplace
spec:
  displayName: ibm-integration-platform-navigator-7.2.4
  publisher: IBM
  image: icr.io/cpopen/ibm-integration-platform-navigator-catalog@sha256:71d5b07bb009e9b111a5755c191a6dd3d5a80c24f371f93d25d30a22d6339a35
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 30m0s
EOF


cat << EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-apiconnect-catalog
  namespace: openshift-marketplace
spec:
  displayName: ibm-apiconnect-5.1.0
  publisher: IBM
  image: icr.io/cpopen/ibm-apiconnect-catalog@sha256:2058d863696e3adccd620ab3210a84f792c2953e42a9b61f350b4ad897723f1e
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 30m0s
EOF

cat << EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-datapower-operator-catalog
  namespace: openshift-marketplace
spec:
  displayName: ibm-datapower-operator-1.9.1
  publisher: IBM
  image: icr.io/cpopen/datapower-operator-catalog@sha256:ca27fcd0c507db3c0370a903caef76b1f0114e57db7eac09f2132b20fb732db2
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 30m0s
EOF


cat << EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: appconnect-operator-catalogsource
  namespace: openshift-marketplace
spec:
  displayName: ibm-appconnect-11.5.0
  publisher: IBM
  image: icr.io/cpopen/appconnect-operator-catalog@sha256:f386adc2e8757eae4fe9e0d04761a8b557fdda0aa7300440a464dc012dc3cf28
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 30m0s
EOF


cat << EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibmmq-operator-catalogsource
  namespace: openshift-marketplace
spec:
  displayName: ibm-mq-3.1.2
  publisher: IBM
  image: icr.io/cpopen/ibm-mq-operator-catalog@sha256:9c9211c1b42caba5ac2dff299945b22649ce600f3f0994077af6d440e4594046
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 30m0s
EOF

cat << EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-cs-iam-catalog
  namespace: openshift-marketplace
spec:
  displayName: ibm-cs-iam-4.5.0
  publisher: IBM
  image: icr.io/cpopen/ibm-iam-operator-catalog@sha256:dd64034fb63a04cb380e81b25d54708bb96080a1b6417d9d068b6f4a1904bebc
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 30m0s
EOF

cat << EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-cs-install-catalog
  namespace: openshift-marketplace
spec:
  displayName: ibm-cs-install-4.6.0
  publisher: IBM
  image: icr.io/cpopen/ibm-cs-install-catalog@sha256:1eb2d3fe9fdbcf1c413de123cd62344e72b4034054b02f08e351839d3f1dda9c
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 30m0s
EOF


cat << EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-zen-operator-catalog
  namespace: openshift-marketplace
spec:
  displayName: ibm-zen-3.1.3
  publisher: IBM
  image: icr.io/cpopen/ibm-zen-operator-catalog@sha256:320db8cf76a866450e1afb76066545aa04675b7f91246587d76eaf17bd92b5e0
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 30m0s
EOF

cat << EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: opencloud-operators
  namespace: openshift-marketplace
spec:
  displayName: ibm-cp-common-services-4.6.0
  publisher: IBM
  image: icr.io/cpopen/ibm-common-service-catalog@sha256:491916cce0da256b7b15d7cb1dc7fdd30465a366a5d8796d0dee898c99cde1a3
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 30m0s
EOF

oc get catalogsource -A

oc patch CatalogSource integration-ibm-cloud-native-postgresql -n openshift-operators --type merge --patch '{"spec":{"grpcPodConfig":{"securityContextConfig":"restricted"}}}'


#Order of installation that works
oc apply -f operators/cert-operator-group.yaml
oc apply -f operators/cert-manager-operator.yaml
oc apply -f operators/cs-operator-group.yaml
oc apply -f operators/cs-operator.yaml
oc apply -f operators/cp4i-operator.yaml

oc apply -f instances/pn.yaml

oc apply -f operators/ace-operator.yaml
oc apply -f operators/mq-operator.yaml
oc apply -f operators/apic-operator.yaml

oc patch CatalogSource integration-ibm-cloud-native-postgresql -n openshift-operators --type merge --patch '{"spec":{"grpcPodConfig":{"securityContextConfig":"restricted"}}}'

#
#oc apply -f operators/
#
#oc apply -f instances/pn.yaml
#oc apply -f instances/apic.yaml