# Deploying the application to K8s

This lab assumes that lab 2.1 has been completed as it uses the same docker image.

## Deploy the application

The `deployment.yaml`contains a description of a Kubernetes deployment that will deploy and manage pods based on the image we created. The `spec`section is the most interesting one, wehre we can see what image is being used as well as the environment variables passed in and ports exposed

```
 spec:
      containers:
      - name: web
        image: web:v1
        env:
        - name: NAME
          value: "My Demo Application"
        ports:
        - containerPort: 80
```

The application can be deployed by running `kubectl`
```
$ kubectl apply -f deployment.yaml
```

The deployment can be viewed by running the following command
```
$ kubectl get deployments -o wide
NAME   DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS   IMAGES                            SELECTOR
web    1         1         1            1           2d20h   web          web:v1   app=web
```

We can also view the pods running, their IP and what node they are assigned to
```
$ kubectl get pods  -o wide
NAME                   READY   STATUS    RESTARTS   AGE     IP           NODE                       NOMINATED NODE
web-6747cfd444-2z285   1/1     Running   0          2d20h   10.244.1.6   docker-desktop   <none>
```

## Expose the application using a service

Since pods are short lived and can come and go based on demand, exposing their IP's to the outside world is not a good idea. Instead a service can be used to expose a group of pods (for example the ones in a deployment). The service will automatically load balance across the available pods

```
kubectl apply -f service.yaml
```

```
$ kubectl get services
NAME          TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)          AGE
kubernetes    ClusterIP      10.0.0.1       <none>          443/TCP          2d20h
web-service   LoadBalancer   10.0.216.170   localhost   8080:31811/TCP   2d20h
```

By entering the http://localhost:8080 in a web browser we can view our applications

## Scale the application up

It is posible to scale the number of pods in a deployment in and out. Kubernetes can even be configured to do that automatically to handle load variations in a cost optimal way

The following command scales out the `web` deployment to 4 pods

```
$ kubectl scale --replicas=4 deployments/web
```

We can now also see that there are 4 pods

```
$ kubectl get pods -o wide
NAME                   READY   STATUS    RESTARTS   AGE     IP            NODE                       NOMINATED NODE
web-6747cfd444-2z285   1/1     Running   0          2d20h   10.244.1.6    docker-desktop   <none>
web-6747cfd444-4z9qc   1/1     Running   0          14s     10.244.1.11   docker-desktop   <none>
web-6747cfd444-4zn44   1/1     Running   0          14s     10.244.0.14   docker-desktop   <none>
web-6747cfd444-bmrgj   1/1     Running   0          15s     10.244.0.13   docker-desktop   <none>
```

By visiting the application in a browser we can see that the IP the application reports will be different for each request as the service loadbalances across all available pods (be sure to disable any browser caching or using `curl` directly).

## Scale the application down

```
$ kubectl scale --replicas=1 deployments/web
```

```
$ kubectl get pods -o wide
NAME                   READY   STATUS        RESTARTS   AGE     IP            NODE                       NOMINATED NODE
web-6747cfd444-2z285   1/1     Running       0          2d20h   10.244.1.6    docker-desktop   <none>
```

## Cleanup
```
kubectl delete -f service.yaml
```
```
kubectl delete -f deployment.yaml
```