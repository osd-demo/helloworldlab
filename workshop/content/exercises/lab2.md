---
Title: Deploy Openshift Dedicated Demo application
PrevPage: ../setup
NextPage: ../finish
---

This lab will guide you in deploying *Shifty* - An OpenShift Demo application on an OpenShift Dedicated cluster. You can find more details on Shifty at https://github.com/openshift-cs/shifty-demo

## Step 1: Create the environment params needed for the deployment

In the terminal window, create secret from file using   
Copy and paste the text below into the file, save and close the file.

```
USERNAME=my_user
PASSWORD=@OtBl%XAp!#632Y5FwC@MTQk
SMTP=localhost
SMTP_PORT=25
```

Create another file called haproxy.config and copy paste the text below in it.
```
global
  maxconn 50000
  log /dev/log local0
  user haproxy
  group haproxy
  stats socket /run/haproxy/admin.sock user haproxy group haproxy mode 660 level admin
  nbproc 2
  nbthread 4
  cpu-map auto:1/1-4 0-3
  ssl-default-bind-ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256
  ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

frontend www.mysite.com
  bind 10.0.0.3:80
  bind 10.0.0.3:443 ssl crt /etc/ssl/certs/mysite.pem
  http-request redirect scheme https unless { ssl_fc }
  use_backend api_servers if { path_beg /api/ }
  default_backend web_servers
```

Create the secrets object from the file using:  
```execute
oc create secret generic shifty-secret --from-file=secret.env
```

Similarly create configmap from file using:
```execute
oc create configmap shifty-config --from-file=haproxy.config
```

## Step 2: Deploy backend microservice

We deploy the microservice first to ensure that the SERVICE environment variables
will be available from the UI application. Using the `app` label allows us to
ensure the UI application and microservice

```execute
oc new-app https://github.com/openshift-cs/shifty-demo
    --name=shifty-microservice \
    --labels=app=shifty-demo
```

Watch the pod creation progress with:
```execute
watch oc get pods -l app=shifty-demo
```
Once you see the pod creation is complete and running, type *cntrl+c* in the terminal
to end the watch.

## Step 3: Deploy the frontend UI application

```execute
oc new-app https://github.com/openshift-cs/shifty-demo \
    --env=MICROSERVICE_NAME=SHIFTY_MICROSERVICE
```

Watch the pod creation progress with:
```execute
watch oc get pods -l app=shifty-demo
```
Once you see the pod creation is complete and running, type *cntrl+c* in the terminal
to end the watch.

## Step 4: Update Deployment to use a "Recreate"

Recreate Deployment strategy helps consistent deployments with persistent volumes

```execute
oc patch dc/shifty-demo -p '{"spec": {"strategy": {"type": "Recreate"}}}'
```

You should see the following on the terminal:
```
deploymentconfig "shifty-demo" patched
```

Watch the pods progress with:
```execute
watch oc get pods -l app=shifty-demo
```
Once you see the pod are running, type *cntrl+c* in the terminal to end the watch


## Step 5: Set a Liveness probe  

Set a Liveness probe on the Deployment to ensure the pod is restarted if something
isn't healthy within the application

```execute
oc set probe dc/shifty-demo --liveness --get-url=http://:8080/health
```

You should see the following on the terminal:
```
deploymentconfig "shifty-demo" updated
```

Watch the pods progress with:
```execute
watch oc get pods -l app=shifty-demo
```
Once you see the pod are running, type *cntrl+c* in the terminal to end the watch

## Step 6: Attach the secrets object to the deployment

```execute
oc set volume deploymentconfig shifty-demo --add \
    --secret-name=shifty-secret \
    --mount-path=/var/secret
```

You should see the following on the terminal:
```
info: Generated volume name: volume-XXXXX
deploymentconfig "shifty-demo" updated
```

Watch the pods progress with:
```execute
watch oc get pods -l app=shifty-demo
```
Once you see the pod are running, type *cntrl+c* in the terminal to end the watch

## Step 7: Create and attach PersistentVolume

```execute
oc set volume dc shifty-demo --add \
    --type=pvc \
    --claim-size=1G \
    -m /var/demo_files
```

You should see the following on the terminal:
```
info: Generated volume name: volume-XXXXX
persistentvolumeclaims/pvc-XXXXX
deploymentconfig "shifty-demo" updated
```

Watch the pods progress with:
```execute
watch oc get pods -l app=shifty-demo
```
Once you see the pod are running, type *cntrl+c* in the terminal to end the watch

## Step 8: Expose the service

Expose the UI application as an OpenShift Route. Using OpenShift Dedicated's included
TLS wildcard certicates, we can easily deploy this as an HTTPS application

```execute
oc create route edge --service=shifty-demo --insecure-policy=Redirect
```

Get the route with:

The output should display the route .

```
shifty-demo-wgordon-XXXX.XXXX.bu-demo.openshiftapps.com
```

Copy and paste the route in a web browser to access the app

## Step 9: Scale application and view Networking section in the application UI

To scale the application to three pods, run:

```execute
oc scale dc shifty-microservice --replicas=3
```

You can verify the status of the pods using:

```execute
oc get pods
```

You should see 3 pods in the "Intra-cluster Communication" section showing traffic flow
between the pods.

## Step 10: Clean up

Run the following to clean up:

```execute
oc delete all,configmap --selector app=shifty-demo
```

You have successfully deployed an application on Red Hat OpenShift Dedicated cluster.   

And yes, it is that easy!!


...
