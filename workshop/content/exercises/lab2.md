---
Title: Deploy Openshift Dedicated Demo application
PrevPage: ../setup
NextPage: ../finish
---

This lab will guide you in deploying *Shifty* - An OpenShift Demo application on an OpenShift Dedicated cluster. You can find more details on Shifty at https://github.com/openshift-cs/shifty-demo

## Step 1: Deploy backend microservice

We deploy the microservice first to ensure that the SERVICE environment variables
will be available from the frontend-UI application. Using the `app` label allows us to
visually link the frontend-UI application and microservice in the Web Console.

```execute
oc new-app https://github.com/openshift-cs/shifty-demo \
    --context-dir=microservice \
    --name=shifty-microservice \
    --labels=app=shifty-demo
```

## Step 2: Deploy the frontend-UI application

```execute
oc new-app https://github.com/openshift-cs/shifty-demo \
    --env=MICROSERVICE_NAME=SHIFTY_MICROSERVICE
```

## Step 3: Update DeploymentConfig strategy to Recreate

Using a Recreate deployment strategy ensures that Read-Write-Once (RWO) persistent
volumes can mount successfully to new deployments:
```execute
oc patch dc/shifty-demo -p '{"spec": {"strategy": {"type": "Recreate"}}}'
```

You should see the following on the terminal:
```
deploymentconfig.apps.openshift.io/shifty-demo patched
```

## Step 4: Set a Liveness probe on the DeploymentConfig

Setting a Liveness probe on the Deployment ensures the pod is restarted if something
isn't healthy within the application:
```execute
oc set probe dc/shifty-demo --liveness --get-url=http://:8080/health
```

You should see the following on the terminal:
```
deploymentconfig.apps.openshift.io/shifty-demo probes updated
```

## Step 5: Create and attach the Secret object to the DeploymentConfig

Create a test Secret object, based on https://github.com/openshift-cs/shifty-demo/blob/master/deployment/examples/secret.env:  
```execute
oc create -f https://raw.githubusercontent.com/openshift-cs/shifty-demo/master/deployment/yaml/secret.yaml
```

Attach the Secret to the DeploymentConfig as a volume:
```execute
oc set volume deploymentconfig shifty-demo --add \
    --secret-name=shifty-secret \
    --mount-path=/var/secret
```

You should see the following in the terminal:
```
info: Generated volume name: volume-XXXXX
deploymentconfig.apps.openshift.io/shifty-demo volume updated
```

## Step 6: Create and attach the ConfigMap object to the DeploymentConfig

Create a test ConfigMap object, based on hhttps://github.com/openshift-cs/shifty-demo/blob/master/deployment/examples/haproxy.config:
```execute
oc create -f https://raw.githubusercontent.com/openshift-cs/shifty-demo/master/deployment/yaml/configmap.yaml
```

Attach the ConfigMap to the DeploymentConfig as a volume:
```execute
oc set volume dc shifty-demo --add \
    --configmap-name=shifty-config \
    -m /var/config
```

You should see the following on the terminal:
```
info: Generated volume name: volume-XXXXX
deploymentconfig.apps.openshift.io/shifty-demo volume updated
```

## Step 7: Create and attach PersistentVolume object to the DeploymentConfig

Create a 1Gi PersistentVolumeClaim and attach it to the DeploymentConfig 
all at once:
```execute
oc set volume dc shifty-demo --add \
    --type=pvc \
    --claim-size=1G \
    -m /var/demo_files
```

You should see the following on the terminal:
```
info: Generated volume name: volume-XXXXX
deploymentconfig.apps.openshift.io/shifty-demo volume updated
```

## Step 8: Expose the service

Expose the frontend-UI application as an OpenShift Route. Using OpenShift Dedicated's included
TLS wildcard certicates, we can easily deploy this as an HTTPS application:
```execute
oc create route edge --service=shifty-demo --insecure-policy=Redirect
```

View the created route URL with:
```execute
oc get route shifty-demo -o template --template='https://{{.spec.host}}'
```

The output should look similar to
```
https://shifty-demo-XXXX-XXXX.993f.bu-demo.openshiftapps.com
```

Copy and paste the route in a web browser to access the app.

## Step 9: Scale microservice and watch how it affects the frontend-UI

From the "Networking" tab in the frontend-UI application, you should see 1
microservice pod currently registered with the frontend.

Scale the microservice to three pods and watch them automatically registry to the frontend:
```execute
oc scale dc shifty-microservice --replicas=3
```

You should see now see 3  microservice pods in the "Intra-cluster Communication" section showing traffic flow
between the pods.

## Step 10: Clean up

Clean up your environment:
```execute
oc delete all --selector app=shifty-demo; \
  oc delete configmap shifty-config; \
  oc delete secret shifty-secret; \
  oc delete pvc --all
```

Congratulations, you have successfully

- Deployed a backend microservice
- Deployed an application
- Hardened the application against unknown issues with a Liveness probe
- Added Secrets and ConfigMaps intended to store private information or configuration overrides
- Added persistent storage to ensure data persists restarts
- Created a TLS secured Route
- Flawlessly and horizontally scaled your backend microservice

Yes, it really is that easy on Red Hat OpenShift Dedicated!!
