# cfm-id-pfsa-app  

![Rebuild architecture diagram](https://github.com/Ishola-github/cfm-id-pfsa-app/actions/workflows/rebuild.yml/badge.svg)

Screening tools for PFAS – *update README to trigger CI*

# PFAS Toxicity Platform  

Regulatory-grade PFAS toxicity prediction combining **QSAR modeling**, **PBPK simulations**, and **computational fragmentation screening**.  
Built with **FastAPI**, **Streamlit**, **R/httk**, and deployed via GitHub Actions + Kubernetes.

---

![Deploy App](https://github.com/Ishola-github/cfm-id-pfsa-app/actions/workflows/deploy.yml/badge.svg)
[![codecov](https://codecov.io/gh/Ishola-github/cfm-id-pfsa-app/branch/main/graph/badge.svg)](https://codecov.io/gh/Ishola-github/cfm-id-pfsa-app)
[![Docker Pulls](https://img.shields.io/docker/pulls/YOUR-DOCKERHUB-USERNAME/pfas-toxicity-platform)](https://hub.docker.com/r/YOUR-DOCKERHUB-USERNAME/pfas-toxicity-platform)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
![Python](https://img.shields.io/badge/python-3.11-blue.svg)

---
## 📑 Table of Contents
- [🎨 Screenshot](#-screenshot)
- [🚀 Features](#-features)
- [📦 Quickstart](#-quickstart)
- [📂 Repository Structure](#-repository-structure)
- [🧩 System Architecture](#-system-architecture)
- [📊 Roadmap](#-roadmap)

---

## 🎨 Screenshot  
![App Screenshot](docs/screenshot.png)  

---
## 🚀 Features
---

- 🧪 **QSAR Modeling**: Machine learning models with RDKit/Mordred descriptors.  
- 📊 **PBPK Integration**: R `httk` package for exposure simulations.  
- 🔬 **Computational Fragmentation**: CFM-ID/MS2PIP integration for PFAS screening.  
- ⚡ **High-Throughput Screening**: ToxCast/Tox21 dataset support.  
- 📑 **Regulatory Compliance**: OECD, EPA TSCA, and ICH M7 aligned reporting.  
- 🔄 **CI/CD Ready**: GitHub Actions + DockerHub + K8s deployment.  

## 🚀 Features
---

- 🧪 **QSAR Modeling**: Machine learning models with RDKit/Mordred descriptors.  
- 📊 **PBPK Integration**: R `httk` package for exposure simulations.  
- 🔬 **Computational Fragmentation**: CFM-ID/MS2PIP integration for PFAS screening.  
- ⚡ **High-Throughput Screening**: ToxCast/Tox21 dataset support.  
- 📑 **Regulatory Compliance**: OECD, EPA TSCA, and ICH M7 aligned reporting.  
- 🔄 **CI/CD Ready**: GitHub Actions + DockerHub + K8s deployment.  

---

## 📦 Quickstart

Clone the repo and build with Docker:

```bash
git clone https://github.com/Ishola-github/cfm-id-pfsa-app.git
cd cfm-id-pfsa-app

# Build image
docker build -t pfas-toxicity-platform .

# Run API + Streamlit UI
docker run -p 8000:8000 -p 8501:8501 pfas-toxicity-platform

# cfm-id-pfsa-app
Screening tools for PSAs
“update README to trigger CI
# PFAS Toxicity Platform

[![CI/CD](https://github.com/Ishola-github/cfm-id-pfsa-app/actions/workflows/deploy.yml/badge.svg)](https://github.com/Ishola-github/cfm-id-pfsa-app/actions/workflows/deploy.yml)
[![codecov](https://codecov.io/gh/Ishola-github/cfm-id-pfsa-app/branch/main/graph/badge.svg)](https://codecov.io/gh/Ishola-github/cfm-id-pfsa-app)
[![Docker Pulls](https://img.shields.io/docker/pulls/your-dockerhub-username/pfas-toxicity-platform)](https://hub.docker.com/r/your-dockerhub-username/pfas-toxicity-platform)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
![Python](https://img.shields.io/badge/python-3.11-blue.svg)

---
## 📑 Table of Contents
- [🚀 Features](#-features)
- [📦 Quickstart](#-quickstart)
- [📂 Repository Structure](#-repository-structure)
- [🏗️ System Architecture](#-system-architecture)
- [📊 Roadmap](#-roadmap)

- ---

## 📊 Roadmap

- [ ] Add extended PBPK model examples  
- [ ] Integrate PFAS dataset from EPA CompTox  
- [ ] Deploy Streamlit app to Hugging Face Spaces  
- [ ] Add CI/CD testing for QSAR + PBPK pipeline  
- [ ] Publish Docker image to DockerHub  


*(Repository slug is `cfm-id-pfsa-app`, but this project is branded as the **PFAS Toxicity Prediction Platform**.)*

A SaaS platform for **regulatory-grade PFAS toxicity prediction** combining **QSAR modeling**, **PBPK simulations**, and **computational fragmentation screening**. Built with **FastAPI**, **Streamlit**, and **R/httk**, and deployed via GitHub Actions + Kubernetes.

---

## 🚀 Features
- **QSAR Modeling** → Machine learning with RDKit + Mordred descriptors  
- **PBPK Integration** → R `httk` package for exposure + kinetics simulations  
- **Computational Fragmentation** → CFM-ID/MS2PIP pipelines for PSA screening  
- **High-Throughput Screening** → ToxCast/Tox21 dataset integration  
- **Regulatory Compliance** → Outputs aligned with OECD, EPA TSCA, ICH M7  
- **Cloud-Ready** → Docker + K8s manifests + GitHub Actions CI/CD  

---

## 📦 Quickstart

Clone and build with Docker:

```bash
git clone https://github.com/Ishola-github/cfm-id-pfsa-app.git
cd cfm-id-pfsa-app

# Build container
docker build -t pfas-toxicity-platform .

# Run API + Streamlit UI
docker run -p 8000:8000 -p 8501:8501 pfas-toxicity-platform

cfm-id-pfsa-app/
├── app/                # FastAPI application code
│   ├── main.py         # Entry point for API
│   ├── routes/         # API endpoints
│   └── models/         # Data models & schemas
├── streamlit_app/      # Streamlit UI
├── worker/             # Celery tasks for async jobs
├── r_service/          # R/httk integration for PBPK
├── Dockerfile          # Container definition
├── requirements.txt    # Python dependencies
├── README.md           # Project documentation
└── .github/workflows/  # GitHub Actions CI/CD configs
flowchart LR
    UI[Streamlit UI] -->|HTTP| API[FastAPI Service]
    API -->|Tasks| Worker[Celery Worker]
    Worker --> Models[QSAR/PBPK Models]
    Worker --> RService[R Service (httk)]
    API --> DB[(PostgreSQL / MongoDB)]
    API --> Cache[(Redis)]
    API --> Monitoring[Prometheus/Grafana]

# PFAS Toxicity Platform
# PFAS Toxicity Platform

[![CI/CD](https://github.com/Ishola-github/cfm-id-pfsa-app/actions/workflows/deploy.yml/badge.svg)](https://github.com/Ishola-github/cfm-id-pfsa-app/actions/workflows/deploy.yml)
[![codecov](https://codecov.io/gh/Ishola-github/cfm-id-pfsa-app/branch/main/graph/badge.svg)](https://codecov.io/gh/Ishola-github/cfm-id-pfsa-app)
[![Docker Pulls](https://img.shields.io/docker/pulls/your-dockerhub-username/pfas-toxicity-platform)](https://hub.docker.com/r/your-dockerhub-username/pfas-toxicity-platform)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
![Python](https://img.shields.io/badge/python-3.11-blue.svg)


[![CI/CD](https://github.com/Ishola-github/cfm-id-pfsa-app/actions/workflows/deploy.yml/badge.svg)](https://github.com/Ishola-github/cfm-id-pfsa-app/actions/workflows/deploy.yml)
[![codecov](https://codecov.io/gh/Ishola-github/cfm-id-pfsa-app/branch/main/graph/badge.svg)](https://codecov.io/gh/Ishola-github/cfm-id-pfsa-app)
[![Docker Pulls](https://img.shields.io/docker/pulls/ishola/pfas-toxicity-platform)](https://hub.docker.com/r/ishola/pfas-toxicity-platform)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Python](https://img.shields.io/badge/python-3.11-blue.svg)](https://www.python.org/)

*(Repository slug is `cfm-id-pfsa-app`, but this project is branded as the PFAS Toxicity Prediction Platform.)*

Update README.md with PFAS Toxicity Platform description

# PFAS Toxicity Platform

*(Repository slug is `cfm-id-pfsa-app`, but this project is branded as the PFAS Toxicity Prediction Platform.)*

A comprehensive SaaS platform for regulatory-grade PFAS (per- and polyfluoroalkyl substances) toxicity prediction using integrated **QSAR**, **PBPK**, and **computational fragmentation** methods.

---

## 🚀 Features
- **QSAR Modeling**: Machine learning models with RDKit/Mordred descriptors.
- **PBPK Integration**: R `httk` package for exposure simulations.
- **Computational Fragmentation**: CFM-ID/MS2PIP integration for PSA screening.
- **High-Throughput Screening**: ToxCast/Tox21 dataset support.
- **Regulatory Compliance**: Reporting aligned with OECD, EPA TSCA, and ICH M7 guidelines.
- **CI/CD Ready**: GitHub Actions for build, test, and deploy to cloud (AWS/Azure/K8s).

---

## 📦 Quickstart

Clone the repo and build with Docker:

```bash
git clone https://github.com/Ishola-github/cfm-id-pfsa-app.git
cd cfm-id-pfsa-app

# Build image
docker build -t pfas-toxicity-platform .

# Run API + Streamlit UI
docker run -p 8000:8000 -p 8501:8501 pfas-toxicity-platform
## 📂 Repository Structure

```bash
cfm-id-pfsa-app/
├── app/                  # FastAPI application code
│   ├── main.py           # Entry point for API
│   ├── routes/           # API endpoints
│   └── models/           # Data models & schemas
├── streamlit_app/        # Streamlit UI
├── worker/               # Celery tasks for async jobs
├── r_service/            # R/httk integration for PBPK
├── Dockerfile            # Container definition
├── requirements.txt      # Python dependencies
├── README.md             # Project documentation
└── .github/workflows/    # GitHub Actions CI/CD configs


---

## 🏗️ System Architecture

```mermaid
flowchart LR
    UI[Streamlit UI] -->|HTTP| API[FastAPI Service]
    API -->|Tasks| Worker[Celery Worker]
    Worker --> Models[QSAR/PBPK Models]
    Worker --> RService[R Service (httk)]
    API --> DB[(PostgreSQL / MongoDB)]
    API --> Cache[(Redis)]
    API --> Monitoring[Prometheus/Grafana]

---

✅ This way, the flow will be:  
**Quickstart → Repository Structure → System Architecture → Roadmap.**

Do you want me to also **update your README with clickable links** (like `[System Architecture](#-system-architecture)` in a Table of Contents at the top)? That way people can jump directly to the diagram.
