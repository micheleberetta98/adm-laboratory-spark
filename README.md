# Create an Spark cluster using Kubernetes

## Requirements

### docker

Docker is an open platform for developing, shipping, and running applications.
Docker enables you to separate your applications from your infrastructure.

Follow installation instructions [here](https://docs.docker.com/get-docker/).

### kind

[kind](https://sigs.k8s.io/kind) is a tool for running local Kubernetes
clusters using Docker container "nodes".

Follow installation instructions [here](https://kind.sigs.k8s.io/docs/user/quick-start/).

### kubectl

The Kubernetes command-line tool, [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/),
allows you to run commands against Kubernetes clusters.
You can use kubectl to deploy applications, inspect and manage cluster
resources, and view logs.

Follow installation instructions [here](https://kubernetes.io/docs/tasks/tools/).

### helm

Helm is the package manager for Kubernetes.
Helm helps you manage Kubernetes applications — Helm Charts help you define,
install, and upgrade even the most complex Kubernetes application.

Follow installation instructions [here](https://helm.sh/docs/intro/install/)

## Deploy Spark

Fortunately we have a Helm chart which deploys all the Spark components.

Clone this repository with:

```bash
git clone https://github.com/matthewrossi/adm-laboratory-spark.git
```

Create a local Kubernetes clusters using Docker container “nodes”:

```bash
kind create cluster --config=kind-config.yaml
```

Install Spark via Helm:

```bash
./install_spark.sh
```

Once the pods are running, you should see:

```bash
> kubectl get pods
NAME             READY   STATUS    RESTARTS   AGE
spark-master-0   1/1     Running   0          42m
spark-worker-0   1/1     Running   0          42m
spark-worker-1   1/1     Running   0          35m
```

## Launch a test job

Get a terminal on a Spark worker node:

```bash
./login_spark.sh
```

You have now access to the Spark 3.3.2 cluster. Launch a test MapReduce job to compute pi:

```bash
spark-submit \
  --master spark://spark-master-svc:7077 \
  --conf spark.jars.ivy=/tmp/ivy2 \
  --class org.apache.spark.examples.SparkPi examples/jars/spark-examples_2.12-3.5.3.jar 100
```

The `--conf` line is to fix a
[possible problem](https://stackoverflow.com/questions/77039532/spark-kafka-integration-basedir-must-be-absolute-ivy2-local#77042840)
when running the Spark job.

## Access the Spark Dashboard

You can also export the Spark dashboard from the cluster to your local machine.

```bash
./expose_spark.sh
```

Connect locally to port 8080 to check the status of the jobs.

## Delete the local Kubernetes cluster

Don't forget to delete the local Kubernetes clusters with:

```bash
kind delete cluster
```

Otherwise `kind` will keep it running even after reboots.
