# Health probes and rolling deployments

## Add a healthprobe

In the deployment yaml, under the container spec add a [readiness probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-readiness-probes
):
```
readinessProbe:
  httpGet:
    path: /
    port: 80
  failureThreshold: 20
  periodSeconds: 5
```
The readiness  probe is of type httpGet, which means it will make a http request to the specified path and port every 5 seconds (periodSeconds). Once the HTTP requests returns 200 the probe will deem the container ready to receive traffic and the pod can be added to the service.

The `deployment.yaml` also sets and environment variable on the container called `STARTUP_DELAY`. This is an artifical delay added to the startup script. When a new pods is created it will take STARTUP_DELAY number of seconds before the application is ready. Set it to a value (20-30) so that you have the chance to observe how pods shift from not ready to ready.

**Apply the service**
```
kubectl apply -f service.yaml
```

**Apply the deployment**
```
kubectl apply -f deployment.yaml
```

Att first when the pod is created it will show as running, but 0/1 in the "Ready" column.

```
NAME                   READY   STATUS      RESTARTS   AGE
web-76b7b5bc56-dp6hg   0/1     Running     0          10s
```

This means that the container inside the pod is not ready and the pod is thus not addd to the service and will not receive any traffic.

As soon as the application is fully started the readiness probe will return HTTP 200 and the pod will be added to the service

```
NAME                   READY   STATUS      RESTARTS   AGE
web-76b7b5bc56-dp6hg   1/1     Running     0          25s
```

**Try to scale the deployment in and out** using `kubectl scale`. Thanks to the readiness probe new pods are not added to the service before they are ready. Since containers start fast (but applications may not) it is essential to have the readiness probes to avoid users being sent to pods that are not ready. 

**Try removing the readiness probe** from `deployment.yaml` and reapply it, then scale out the delployment. If you hit the servcie repeatedely at least some of your requests will hit the not ready pod, resulting either in timeouts or very long delays.

A good way to hit the pods is using curl
```
curl http://localhost:8080
```

## Make a rolling update

With the readiness probe in place it is now possible to make rolling updates to Kubernetes without any downtime noticeable by the end user.

During a rolling update the pods are replaced one by one (or chunk by chunk) by new pods with the new specification.

In order to do rolling deployments, add a strategy under `.spec.templates.spec` add a strategy:
```
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 1
```
*Also make sure that the readiness probe is in place*

**The maxSurge value** indicates how many extra pods can be spun up during rolling a rolling update 

**The maxUnavailable value** indicates how many pods can be unavailable at any given point in time during the rolling update

**Apply the deployment**
```
kubectl apply -f deployment.yaml
```

### Example scanerio
1. Scalce the web deployment to 5
```
kubectl scale --replicas=5 web
```
2. Wait until all are started

3. Update the environment variable NAME
```
kubectl set env deployment/web NAME="My New Name"
```

**Observe how the deployment is being rolled out by running `kubectl get pods`**
```
web-58df744df5-8r5dw   1/1     Running       0          65s
web-58df744df5-qn6jb   1/1     Terminating   0          65s
web-58df744df5-r8zxl   1/1     Running       0          65s
web-58df744df5-xxpg9   1/1     Running       0          2m20s
web-58df744df5-zk2fm   1/1     Running       0          65s
web-c68fdcc69-2szdn    0/1     Running       0          5s
web-c68fdcc69-s6rxz    0/1     Running       0          5s
```
*Note that the  number sequence in the podname is either `58df744df5` or `c68fdcc69`. This is because there are now two replicasets during the update, one old and one new. Once the rolling update is done only the new replicaset `c68fdcc69`will remain*

- At any point in time there should always be at least 4 running and ready pods (maxunavailable is set to 1 and 5-1=4).
- At any point in time there should be at most 6 (maxSurge is set to 1 and 5+1=6).

During a rolling upgrade you will seedifferent results when visiting the page (depnding on which pod you are redirected to), but you should never see any outages thanks to the readiness probe.

### Adjust maxSurge and maxUnavailable
Play around with the `maxSurge` and `maxUnavailable` settings. Keep in mind that you can use precentages instead of absolute values

1. Create a strategy that maintains capacity (i.e always keeps the the 5 replicas up), but does not require a huge overhead room in the cluster
2. Create a strategy that maintains capacity (i.e always keeps the the 5 replicas up) and performs the update as fast as possible
3. Create a strategy that updates 25% of the pods at the time, no matter how many there are.