# ⚓ Kubernetes Migration Guide
## From Docker Compose to Production-Ready K8s

Transform your Docker Compose knowledge into Kubernetes expertise with step-by-step migration paths for all 15 projects.

## 🎯 Learning Objectives

By the end of this guide, you'll be able to:
- **Convert** Docker Compose files to Kubernetes manifests
- **Deploy** multi-container applications on Kubernetes
- **Implement** production-ready configurations
- **Monitor** and **scale** applications effectively
- **Apply** GitOps principles for automated deployments

## 🗺️ Migration Roadmap

### Phase 1: Kubernetes Fundamentals (Week 1)
- 📚 [Core Concepts](./fundamentals/core-concepts.md)
- 🔧 [kubectl Essentials](./fundamentals/kubectl-guide.md)
- 🏗️ [First Deployment](./fundamentals/first-deployment.md)

### Phase 2: Workload Migration (Week 2)
- 🔄 [Pods & Deployments](./workloads/pods-deployments.md)
- 📊 [Services & Networking](./workloads/services-networking.md)
- 💾 [Storage & Volumes](./workloads/storage-volumes.md)

### Phase 3: Configuration Management (Week 3)
- ⚙️ [ConfigMaps & Secrets](./configuration/configmaps-secrets.md)
- 🌍 [Environment Management](./configuration/environments.md)
- 🔐 [Security Best Practices](./configuration/security.md)

### Phase 4: Production Readiness (Week 4)
- 📈 [Monitoring & Observability](./production/monitoring.md)
- 🔄 [Scaling & Performance](./production/scaling.md)
- 🚀 [CI/CD Integration](./production/cicd.md)

## 📊 Project Migration Matrix

| Docker Compose Project | K8s Complexity | Migration Guide | K8s Features Used |
|------------------------|----------------|-----------------|-------------------|
| **p1** - Node.js + MongoDB | ⭐ Basic | [📖 Guide](./migrations/p1-to-k8s.md) | Deployment, Service, PVC |
| **p2** - React + Express + PostgreSQL | ⭐⭐ Intermediate | [📖 Guide](./migrations/p2-to-k8s.md) | Multi-container, ConfigMap |
| **p3** - Load Balanced Nginx | ⭐⭐ Intermediate | [📖 Guide](./migrations/p3-to-k8s.md) | Ingress, HPA |
| **p4** - WordPress + MySQL | ⭐⭐ Intermediate | [📖 Guide](./migrations/p4-to-k8s.md) | StatefulSet, PV/PVC |
| **p5** - ELK Stack | ⭐⭐⭐ Advanced | [📖 Guide](./migrations/p5-to-k8s.md) | Logging, DaemonSet |
| **p6** - Django + Celery | ⭐⭐⭐ Advanced | [📖 Guide](./migrations/p6-to-k8s.md) | Jobs, CronJobs |
| **p7** - Microservices + RabbitMQ | ⭐⭐⭐⭐ Expert | [📖 Guide](./migrations/p7-to-k8s.md) | Service Mesh, RBAC |
| **p8** - CI/CD Pipeline | ⭐⭐⭐⭐ Expert | [📖 Guide](./migrations/p8-to-k8s.md) | Operators, CRDs |
| **p9** - Multi-Database | ⭐⭐⭐ Advanced | [📖 Guide](./migrations/p9-to-k8s.md) | StatefulSets, Operators |
| **p10** - Kafka Streaming | ⭐⭐⭐⭐ Expert | [📖 Guide](./migrations/p10-to-k8s.md) | Kafka Operator |
| **p11** - Next.js + GraphQL | ⭐⭐⭐ Advanced | [📖 Guide](./migrations/p11-to-k8s.md) | Ingress, TLS |
| **p12** - Gaming Platform | ⭐⭐⭐⭐ Expert | [📖 Guide](./migrations/p12-to-k8s.md) | WebSocket, HPA |
| **p13** - Data Science Stack | ⭐⭐⭐⭐⭐ Master | [📖 Guide](./migrations/p13-to-k8s.md) | Spark Operator, JupyterHub |
| **p14** - Production Infrastructure | ⭐⭐⭐⭐⭐ Master | [📖 Guide](./migrations/p14-to-k8s.md) | Istio, Prometheus |
| **p15** - Kubernetes Tools | ⭐⭐⭐⭐⭐ Master | [📖 Guide](./migrations/p15-to-k8s.md) | Native K8s deployment |

## 🚀 Quick Start Examples

### Example 1: Simple Web App (p1 → K8s)

**Docker Compose (p1/docker-compose.yml):**
```yaml
version: '3.8'
services:
  backend:
    image: node:18
    ports:
      - "3000:3000"
    environment:
      MONGO_URL: mongodb://mongodb:27017/mydb
  mongodb:
    image: mongo:latest
    volumes:
      - mongo_data:/data/db
volumes:
  mongo_data:
```

**Kubernetes Migration:**

1. **Deployment for Node.js app:**
```yaml
# k8s/backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  labels:
    app: backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: node:18
        ports:
        - containerPort: 3000
        env:
        - name: MONGO_URL
          value: "mongodb://mongodb:27017/mydb"
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
```

2. **Service for backend:**
```yaml
# k8s/backend-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  selector:
    app: backend
  ports:
  - port: 3000
    targetPort: 3000
  type: ClusterIP
```

3. **StatefulSet for MongoDB:**
```yaml
# k8s/mongodb-statefulset.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
spec:
  serviceName: mongodb
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
      - name: mongodb
        image: mongo:latest
        ports:
        - containerPort: 27017
        volumeMounts:
        - name: mongo-storage
          mountPath: /data/db
  volumeClaimTemplates:
  - metadata:
      name: mongo-storage
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

### Migration Commands:
```bash
# Convert using kompose (automated)
kompose convert -f docker-compose.yml

# Apply to cluster
kubectl apply -f k8s/

# Verify deployment
kubectl get pods,svc,pvc
```

## 🎓 Migration Strategies

### Strategy 1: Direct Translation
**Best for:** Simple applications (p1-p3)
```bash
# Install kompose
curl -L https://github.com/kubernetes/kompose/releases/latest/download/kompose-linux-amd64 -o kompose
chmod +x kompose && sudo mv kompose /usr/local/bin

# Convert compose file
kompose convert -f docker-compose.yml

# Review and adjust generated manifests
```

### Strategy 2: Helm Charts
**Best for:** Complex applications (p4-p8)
```bash
# Create Helm chart
helm create my-app

# Customize values.yaml
# Deploy with Helm
helm install my-app ./my-app-chart
```

### Strategy 3: Operators
**Best for:** Stateful applications (p9-p15)
```bash
# Use existing operators
kubectl apply -f https://operatorhub.io/kafka-operator

# Or create custom operator
operator-sdk init --domain=example.com --repo=github.com/example/my-operator
```

## 🔧 Essential Tools

### Development Tools
```bash
# kubectl - Kubernetes CLI
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# k9s - Terminal UI for Kubernetes
curl -sS https://webinstall.dev/k9s | bash

# kubectx/kubens - Context switching
git clone https://github.com/ahmetb/kubectx.git
```

### Cluster Management
```bash
# kind - Local Kubernetes
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64

# k3s - Lightweight Kubernetes
curl -sfL https://get.k3s.io | sh -

# minikube - Local development
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
```

### GitOps Tools
```bash
# ArgoCD - GitOps for Kubernetes
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Flux - GitOps Toolkit
curl -s https://fluxcd.io/install.sh | sudo bash
```

## 📈 Production Considerations

### Security Hardening
- **RBAC:** Role-based access control
- **Network Policies:** Traffic isolation
- **Pod Security Standards:** Container security
- **Secret Management:** External secret operators

### Monitoring & Observability
- **Prometheus:** Metrics collection
- **Grafana:** Visualization dashboards
- **Jaeger:** Distributed tracing
- **Fluentd:** Log aggregation

### High Availability
- **Multi-zone deployments**
- **Pod Disruption Budgets**
- **Horizontal Pod Autoscaling**
- **Cluster Autoscaling**

## 🎯 Hands-On Exercises

### Exercise 1: Convert Your First App
```bash
# Choose a simple project (p1-p3)
cd p1

# Install local Kubernetes cluster
kind create cluster --name learning

# Convert and deploy
kompose convert
kubectl apply -f .

# Verify deployment
kubectl get all
```

### Exercise 2: Implement Health Checks
```yaml
# Add to your deployment
spec:
  template:
    spec:
      containers:
      - name: app
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
```

### Exercise 3: Configure Auto-scaling
```yaml
# HorizontalPodAutoscaler
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: backend-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: backend
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

## 🌐 Advanced Topics

### Service Mesh with Istio
```bash
# Install Istio
curl -L https://istio.io/downloadIstio | sh -
istioctl install --set values.defaultRevision=default

# Enable sidecar injection
kubectl label namespace default istio-injection=enabled
```

### Custom Resource Definitions
```yaml
# Example: Database CRD
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: databases.example.com
spec:
  group: example.com
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              size:
                type: string
              version:
                type: string
```

## 🎯 Certification Path

### Kubernetes Certifications
1. **CKAD** - Certified Kubernetes Application Developer
2. **CKA** - Certified Kubernetes Administrator  
3. **CKS** - Certified Kubernetes Security Specialist

### Preparation Resources
- 📚 [CKAD Study Guide](./certifications/ckad-prep.md)
- 🧪 [Practice Exams](./certifications/practice-exams.md)
- 🎥 [Video Tutorials](./certifications/video-resources.md)

## 🤝 Community & Resources

### Learning Resources
- 📖 [Kubernetes Documentation](https://kubernetes.io/docs/)
- 🎓 [CNCF Training](https://training.linuxfoundation.org/training/kubernetes-fundamentals/)
- 🌐 [Kubernetes Academy](https://kubernetes.academy/)

### Community
- 💬 [CNCF Slack](https://slack.cncf.io/)
- 📚 [Reddit r/kubernetes](https://reddit.com/r/kubernetes)
- 🎪 [KubeCon Events](https://events.linuxfoundation.org/kubecon-cloudnativecon-north-america/)

## 🚀 Next Steps

1. **Start with basics:** Complete [Core Concepts](./fundamentals/core-concepts.md)
2. **Practice migration:** Convert p1-p3 projects
3. **Learn production patterns:** Study p6-p10 migrations
4. **Master advanced topics:** Explore service mesh and operators
5. **Get certified:** Prepare for CKAD/CKA exams

Ready to begin your Kubernetes journey? Start with [Kubernetes Core Concepts](./fundamentals/core-concepts.md)!

---

**🎯 Remember:** The journey from Docker Compose to Kubernetes is about understanding distributed systems, not just learning new syntax. Focus on the concepts, and the tools will follow!
