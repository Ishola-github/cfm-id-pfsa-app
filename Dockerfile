name: Build and Push to Docker Hub

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v6
        with:
          context: .
          file: ./Dockerfile
          push: true
          no-cache: true
          platforms: linux/amd64
          tags: |
            sundayayobami/pfas-msms-tox:latest
            sundayayobami/pfas-msms-tox:${{ github.sha }}

      - name: Image digest
        run: echo "Image pushed successfully to Docker Hub! ✅"