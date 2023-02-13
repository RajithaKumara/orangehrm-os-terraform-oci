[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/RajithaKumara/orangehrm-os-terraform-oci/archive/develop.zip)


Limitation:
- Not supporting multi nodes (not using load balancer)
- Only supporting `Oracle Autonomous Linux` image
- Cannot use existing MySQL Database Service (MDS)
- Can provision resources only within a single compartment

Known issues:
- Setting up LDAP
- Setting up Email configurations
