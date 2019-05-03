---
Title: Deploy a simple application
PrevPage: ../setup
NextPage: ../finish
---

This lab will guide you through deploying a Node.js 'Hello World' application to the OpenShift Dedicated cluster.

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

## Step 6: Scale application

To scale the application to three pods, run:

```execute
oc scale dc nodejs-hello-world --replicas=3
```

You can verify the status of the pods using:

```execute
oc get pods
```

Verify that the service is running by accessing the route from Step 6
in a web browser.

## Step 7: Clean up

Run the following to clean up: 

```execute
oc delete all --selector app=nodejs-hello-world
```

You have successfully deployed an application on Red Hat OpenShift Dedicated cluster.   

And yes, it is that easy!!



...
