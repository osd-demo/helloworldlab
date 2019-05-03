Description
================

This repository contains set of instructions to deploy a Katacoda-styled lab on OpenShift Dedicated cluster. The lab provides instructions to deploy a simple Node.js application on the cluster.  


Installation
================

To deploy the lab, it is recommended you first create a fresh project into which to deploy it. The same project will then be used by the lab.

```
oc new-project workshop
```

In the active project you want to use, run:

```
oc new-app https://github.com/openshift-labs/workshop-spawner/blob/3.0.7/templates/learning-portal-production.json --param PROJECT_NAME=yourproject --param CONSOLE_BRANDING=dedicated
```

To get the hostname, run:

```
oc get route 
```

Use your browser to access the lab.

You may need to supply your login/password again for the OpenShift cluster you deployed the sample workshop to. You will only be able to access it if you are a project admin of the project it is deployed to.

When you are finished you can delete the project you created, or if you used an existing project, run:

```
oc delete all,serviceaccount,rolebinding,configmap -l app=sample
```

Note that this will not delete anything which may have been deployed when you went through the sample workshop. Ensure that you go right through the workshop and execute any steps described in it for deleting any deployments it has you make.


