---
Title: Deploy Openshift Dedicated Demo application
PrevPage: lab1
NextPage: lab3
---

This lab will guide you through deploying openshift-dedicated-demo application to the OpenShift Dedicated cluster.

## Step 1: Create application

The command below will create the application. As a reminder, you can click on the <span class="glyphicon glyphicon-play-circle"></span> icon shown to the right of the command to copy and run the command in the interactive terminal.  

```execute
oc new-app https://github.com/openshift-cs/openshift-dedicated-demo.git
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
oc describe svc/openshift-dedicated-demo
```

The output should display the service details such as: Namespace, IP,
Port, etc.

## Step 4: Expose service

You can expose the service so that external users can access it using:

```execute
oc expose svc/openshift-dedicated-demo
```

Next, get the route for the service:

```execute
oc get route
```

The output should display the route like below.

```
openshift-dedicated-demo-workshop-XXXX.XXXX.bu-demo.openshiftapps.com
```

Copy and paste the route in a web browser. The browser should display "Hello World".

## Step 5: Clean up

Run the following to clean up:

```execute
oc delete all --selector app=openshift-dedicated-demo
```

You have successfully deployed an application on Red Hat OpenShift Dedicated cluster.   

And yes, it is that easy!!



...
