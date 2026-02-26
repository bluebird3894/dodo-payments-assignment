# EKS Unified Observability & Networking Project

A production-grade DevOps project demonstrating a unified networking architecture, automated CI/CD, and a full observability stack (Prometheus, Grafana) on Amazon EKS.

## Key Features
* **Unified Networking**: Consolidated multiple Application Load Balancers (ALBs) into a single ALB using **Ingress Groups** to optimize cost and performance.
* **Observability Stack**: Full-stack monitoring using **Prometheus** for metrics, visualized through custom **Grafana** dashboards.
* **Automated Alerting**: Real-time alerting integrated with **Amazon SNS** using IAM Node Roles for secure, keyless authentication.
* **Security & SSL**: End-to-end encryption with **AWS Certificate Manager (ACM)** and least-privilege IAM policies.

## Tech Stack
* **Cloud**: AWS (EKS, ALB, Route 53, SNS, IAM)
* **Containers**: Kubernetes, Docker
* **Monitoring**: Prometheus, Grafana, Promtail
* **Infrastructure**: Helm, AWS Load Balancer Controller, EBS CSI Driver

## Architecture Overview
The project uses a path-based and host-based routing strategy:
- `app.urtechmitra.link` -> Frontend Service
- `api.urtechmitra.link` -> Backend API
- `grafana.urtechmitra.link` -> Monitoring Dashboard

## Monitoring & Alerting
- **Metrics**: Tracked Node CPU/Memory ratios and Pod-level saturation.
- **Logs**: Centralized logs from all namespaces using Promtail.
- **Alerting**: Configured Grafana Alert Rules to trigger SNS notifications when CPU usage exceeds 80%.

## Security Implementation (Task 4)
Instead of using static AWS Access Keys, this project utilizes **IAM Roles for Service Accounts (IRSA)** and Node-level permissions to allow Grafana to publish directly to SNS topics securely.

![app diagram](https://github.com/user-attachments/assets/7b8003e1-9f89-49ae-8f83-1763068c0ac0)
[app diagram.drawio](https://github.com/user-attachments/files/25576423/app.diagram.drawio)
