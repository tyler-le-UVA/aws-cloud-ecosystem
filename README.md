# Serverless AWS Ecosystem & Automated CI/CD Pipeline

A production-grade, serverless cloud architecture built with **Terraform (IaC)**, **AWS Lambda**, **API Gateway**, and **DynamoDB**, fully automated via a **GitHub Actions CI/CD pipeline** featuring automated security linting.

---

## 🏗️ Architecture Overview

This project implements a secure, event-driven backend service designed to handle data ingestion (such as user music ratings for the *Duple* mobile platform):

1. **API Gateway (HTTP API):** Acts as the secure public entry point exposing a POST `/rate` endpoint.
2. **AWS Lambda (Python):** Processes incoming payloads, validates data structures, and handles business logic in a secure serverless compute environment.
3. **Amazon DynamoDB:** A NoSQL database serving as the persistence layer with a dedicated `user-ratings` table.
4. **Remote State Management:** Terraform state is securely isolated and managed in a dedicated Amazon S3 bucket with versioning.

---

## 🚀 Key Features & Engineering Practices

* **Infrastructure as Code (IaC):** Entire cloud infrastructure is provisioned, managed, and version-controlled using Terraform.
* **Automated CI/CD:** Integrated **GitHub Actions** pipeline that automatically triggers on pushes to `main` to run `terraform init`, `plan`, and `apply`.
* **DevSecOps Shift-Left Security:** Incorporates static analysis security testing (SAST) via **Checkov** directly into the deployment pipeline to catch misconfigurations early.
* **Least-Privilege Security:** IAM roles and policies are tightly scoped so the Lambda function possesses *only* the granular permissions required to write to the designated DynamoDB table.

---

## 📁 Repository Structure

```text
aws-cloud-ecosystem/
├── .github/
│   └── workflows/
│       └── deploy.yml       # Automated CI/CD pipeline configuration
├── api_gateway.tf           # API Gateway routes, integrations, and permissions
├── dynamodb.tf              # DynamoDB table definitions (`user-ratings`)
├── lambda.tf                # Lambda function provisioning and zip packaging
├── main.tf                  # Backend configuration, provider settings, and IAM roles
├── lambda.zip               # Deployment package containing Python handler logic
└── .terraform.lock.hcl      # Terraform provider dependency lock file
