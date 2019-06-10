---
Title: Deploy Storage for a simple application
PrevPage: lab2
NextPage: ../finish
---

This lab will guide you through deploying Storage for Node.js 'Hello World' application on an OpenShift Dedicated cluster.

## Step 1: Create application

The command below will create the application. As a reminder, you can click on the <span class="glyphicon glyphicon-play-circle"></span> icon shown to the right of the command to copy and run the command in the interactive terminal.  

```execute
oc new-app https://github.com/rkratky/nodejs-hello-world.git
```

The output should display the below success message:

```
...
--> Success
    Build scheduled ...
...
```

## Step 2: Verify status

You can verify the build status using the following command:

```execute
oc describe build  
```

You can verify the pod status using:

```execute
oc get pods
```
The output should display the build pod and application pod status as 'Running' or 'Completed' depending on whether or not the build has finished. Eventually, the build pod status will be 'Completed' and the application pod status will be 'Running'.

## Step 3: View service details

You can view the service details using:

```execute
oc describe svc/nodejs-hello-world
```

The output should display the service details such as: Namespace, IP,
Port, etc.

## Step 4: Verify service

To verify the service functionality, look up the service IP address using:

```execute
oc describe svc/nodejs-hello-world | grep IP
```

Copy and paste the below curl command in the terminal window. Replace 'IP' with the service IP address from the previous step.

```
curl <IP>:8080
```

You should see "Hello World" in the terminal.

## Step 5: Expose service

You can expose the service so that external users can access it using:

```execute
oc expose svc/nodejs-hello-world
```

Next, get the route for the service:

```execute
oc get route
```

The output should display the route like below.

```
nodejs-hello-world-portal-workshop-XXXX.XXXX.bu-demo.openshiftapps.com.
```

Copy and paste the route in a web browser. The browser should display "Hello World".

## Step 6: Deploy storage for the application with the steps below:

Get the deployment config for the application:

```execute
oc get dc
```

Changing the config to add the Persistent Volume claim:

```execute
oc set volume dc/nodejs-hello-world --add --name=tmp-mount --claim-name=data --type pvc --claim-size=1G --mount-path /mnt
```

You will see the following on the terminal:
```
deploymentconfig.apps.openshift.io/nodejs-hello-world volume updated
```

Rollout the new config:

```execute
oc rollout status dc/nodejs-hello-world
```

You will see the following on terminal:
```
replication controller "nodejs-hello-world-2" successfully rolled out
```

You can verify the PVC status using:

```execute
oc get pvc
```
You will see the following on terminal:
```
data      Bound     pvc-<>   1Gi        RWO            gp2-encrypted
```

You can verify the status on the pods using the pod name with the commands below:

* oc get pods
Get the pod name from the oc get pods output and execute the following in the terminal
* oc describe pod <nodejs-hello-world-2-XXXX> pod

You will see the following with the describe pod output:
```
Displayed:
———————
    Mounts:
      /mnt from tmp-mount (rw)

Volumes:
  tmp-mount:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same name
space)
    ClaimName:  data
—————————

```


Verify that the service is running by accessing the route from Step 6
in a web browser.

## Step 7: Clean up

Run the following to clean up:

```execute
oc delete all,configmap --selector app=nodejs-hello-world
```

You have successfully deployed storage with an application on Red Hat OpenShift Dedicated cluster.   


...
