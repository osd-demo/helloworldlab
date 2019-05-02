---
Title: Deploying a simple application on OpenShift Dedicated cluster
PrevPage: ../setup
NextPage: ../finish
---

Lets deploy a simple nodejs hello world application on the OpenShift Dedicated cluster.

We start by creating a new application on the cluster. Copy and paste the command below in the terminal. Alternatively, You can click on any command which has the <span class="glyphicon glyphicon-play-circle"></span> icon shown to the right of it, and it will be copied to the interactive terminal and it will run it for you.  

```execute
oc new-app registry.access.redhat.com/openshift3/nodejs-010-rhel7~https://github.com/rkratky/nodejs-hello-world.git
```

You should see text on the termainal that looks something like

```
--> Success
    Build scheduled for "nodejs-hello-world"
```

Check the status of the deployment with the status command
```execute
oc status -v
```

Verify the build status with the command:

```execute
oc describe build  
```

And pod status with:
```execute
oc get pods
```

Get pods should show you pods are running and deployment is complete. What is the service we just deployed? Lets take a look at it with:

```execute
oc describe svc/nodejs-hello-world
```

You should see the service running successfully. Okay, now that you know your service is running, lets test the service to make sure it is doing the right thing.
First, get the IP address for the service using the following command

```execute
oc describe svc/nodejs-hello-world | grep IP
```

Next, Use curl on the IP address to see if the Hello World application works:

```execute
curl <IP>:8080
```

You should see "Hello World" on the terminal.
But this service is only accessible to you. You may need customers and users to access it. To do this we expose the service as follows:

```execute
oc expose svc/nodejs-hello-world
```

Get the route for the service with:

```execute
oc get route
```

Your customers can now access your service over the internet using the route which looks something like nodejs-hello-world-portal-workshop-XXXX.XXXX.bu-demo.openshiftapps.com. Copy the route and open into a web browser window.

You should see "Hello World" in the browser.

Next, Your application gets really popular with the users and customers and there is a lot of demand for it so you would like to scale the application deployment to meet the demands. Here is how you can do it:

```execute
oc scale dc nodejs-hello-world --replicas=3
```
Check status of the pods

```execute
oc get pods
```

Also check if the Serivce is still available to the customers on the web browser with the route you used earlier.

You will notice that the application scales seamlessly without any disruption to the service.  

Congratulations! You have successfully deployed an Application on Openshift Dedicated.   

And yes, it is that easy!!


...
