 apic client-creds:set /Users/dallibagdi/Downloads/gox-credentials.json
 apic login --username gxo-org-admin --password 7iron-hide! --server https://api.manager.apps.itzocp-5500054bqe-c73sp4lh.cp.fyre.ibm.com  --realm provider/default-idp-2

apic registrations:create --server $SERVER ace-registration.json
apic registrations:get ace-registration --server $SERVER --output -



 apic login --username admin --password 7iron-hide! --server https://cloud.manager.apps.itzocp-5500054bqe-c73sp4lh.cp.fyre.ibm.com  --realm admin/default-idp-1
