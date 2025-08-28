# cfm-id-pfsa-app
Screening tools for PSAs
“update README to trigger CI
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
