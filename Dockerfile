# Use a small Python base
FROM python:3.11-slim

# Safe defaults
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# OS deps (curl used by HEALTHCHECK)
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# App files
WORKDIR /app
COPY requirements.txt .fastapi==0.111.0
uvicorn[standard]==0.30.0


RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your source
COPY . .

# Azure Container Apps default inbound port is 8080
EXPOSE 8080

# Simple container health probe
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s \
  CMD curl -fsS http://127.0.0.1:8080/healthz || exit 1

# FROM python:3.11-slim

# Safe defaults
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# OS deps (curl used by HEALTHCHECK)
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# App files
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

# Azure Container Apps default inbound port is 8080
EXPOSE 8080

# Simple container health probe
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s \
  CMD curl -fsS http://127.0.0.1:8080/healthz || exit 1

# Start the API (note: no spaces, and it's app.main:app)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
Start the API (FastAPI/Uvicorn example)
RUN adduser --disabled-password --gecos '' appuser
USER appuser


# Dockerfile.api - Main FastAPI Application
FROM python:3.11-slim as base

# Create non-root user for security
RUN groupadd -r pfas && useradd -r -g pfas pfas

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc g++ \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY src/ ./src/
COPY models/ ./models/
COPY data/ ./data/

# Set proper ownership
RUN chown -R pfas:pfas /app

# Switch to non-root user
USER pfas

# Environment variables
ENV PYTHONPATH=/app/src
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Fix: Use port 8000 consistently (FastAPI default)
EXPOSE 8000

# Health check with correct port
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl -f http://127.0.0.1:8000/health || exit 1

# Use Gunicorn with Uvicorn workers for production
CMD ["gunicorn", "src.main:app", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8000", "--access-logfile", "-", "--error-logfile", "-"]

---
# Dockerfile.worker - Celery Worker for QSAR/PBPK Processing
FROM python:3.11-slim

# Create non-root user
RUN groupadd -r pfas && useradd -r -g pfas pfas

# Install system dependencies including R
RUN apt-get update && apt-get install -y \
    gcc g++ \
    libpq-dev \
    r-base r-base-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages for PBPK modeling
RUN R -e "install.packages(c('httk', 'jsonlite', 'dplyr', 'data.table'), repos='https://cran.rstudio.com/')"

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY src/ ./src/
COPY models/ ./models/
COPY r_environment/ ./r_environment/

# Set ownership
RUN chown -R pfas:pfas /app

USER pfas

# Environment variables
ENV PYTHONPATH=/app/src
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV C_FORCE_ROOT=1

# Celery worker command
CMD ["celery", "-A", "src.celery_app", "worker", "--loglevel=info", "--concurrency=4", "--max-tasks-per-child=100"]

---
# docker-compose.yml - Complete PFAS Platform Stack
version: '3.8'

services:
  # Main API Service
  pfas-api:
    build:
      context: .
      dockerfile: Dockerfile.api
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://pfas_user:${POSTGRES_PASSWORD}@postgres:5432/pfas_db
      - MONGODB_URL=mongodb://mongo:27017/pfas_results
      - REDIS_URL=redis://:${REDIS_PASSWORD}@redis:6379/0
      - CELERY_BROKER=redis://:${REDIS_PASSWORD}@redis:6379/1
      - CELERY_BACKEND=redis://:${REDIS_PASSWORD}@redis:6379/2
      - AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
      - AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
      - JWT_SECRET_KEY=${JWT_SECRET_KEY}
    volumes:
      - ./models:/app/models:ro
      - ./data:/app/data:ro
      - api_logs:/app/logs
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
      mongo:
        condition: service_healthy
    networks:
      - pfas-network
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
        reservations:
          memory: 512M
          cpus: '0.5'

  # Celery Workers for QSAR/PBPK Processing
  pfas-worker:
    build:
      context: .
      dockerfile: Dockerfile.worker
    environment:
      - DATABASE_URL=postgresql://pfas_user:${POSTGRES_PASSWORD}@postgres:5432/pfas_db
      - MONGODB_URL=mongodb://mongo:27017/pfas_results
      - REDIS_URL=redis://:${REDIS_PASSWORD}@redis:6379/0
      - CELERY_BROKER=redis://:${REDIS_PASSWORD}@redis:6379/1
      - CELERY_BACKEND=redis://:${REDIS_PASSWORD}@redis:6379/2
    volumes:
      - ./models:/app/models:ro
      - ./r_environment:/app/r_environment:ro
      - worker_logs:/app/logs
    depends_on:
      redis:
        condition: service_healthy
      postgres:
        condition: service_healthy
    networks:
      - pfas-network
    restart: unless-stopped
    deploy:
      replicas: 3
      resources:
        limits:
          memory: 4G
          cpus: '2.0'
        reservations:
          memory: 1G
          cpus: '1.0'

  # PostgreSQL with Chemical Structure Support
  postgres:
    image: postgres:15
    environment:
      - POSTGRES_DB=pfas_db
      - POSTGRES_USER=pfas_user
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_INITDB_ARGS=--encoding=UTF-8 --lc-collate=C --lc-ctype=C
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./sql/init_db.sql:/docker-entrypoint-initdb.d/01-init.sql
    ports:
      - "5432:5432"
    networks:
      - pfas-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U pfas_user -d pfas_db"]
      interval: 30s
      timeout: 10s
      retries: 5
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '0.5'

  # MongoDB for Computational Results
  mongo:
    image: mongo:7.0
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=${MONGO_PASSWORD}
      - MONGO_INITDB_DATABASE=pfas_results
    volumes:
      - mongo_data:/data/db
      - ./mongo/init_collections.js:/docker-entrypoint-initdb.d/init.js:ro
    ports:
      - "27017:27017"
    networks:
      - pfas-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "mongosh", "--quiet", "--eval", "db.adminCommand('ping').ok"]
      interval: 30s
      timeout: 10s
      retries: 5
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '0.5'

  # Redis for Caching and Job Queue
  redis:
    image: redis:7-alpine
    command: >
      redis-server 
      --requirepass ${REDIS_PASSWORD}
      --maxmemory 1gb 
      --maxmemory-policy allkeys-lru
      --save 900 1
      --save 300 10
      --save 60 10000
    volumes:
      - redis_data:/data
    ports:
      - "6379:6379"
    networks:
      - pfas-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "${REDIS_PASSWORD}", "ping"]
      interval: 30s
      timeout: 10s
      retries: 5

  # Nginx Reverse Proxy
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/ssl:/etc/nginx/ssl:ro
      - nginx_logs:/var/log/nginx
    depends_on:
      - pfas-api
    networks:
      - pfas-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Monitoring Stack
  prometheus:
    image: prom/prometheus:latest
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=30d'
    ports:
      - "9090:9090"
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    networks:
      - pfas-network
    restart: unless-stopped

volumes:
  postgres_data:
    driver: local
  mongo_data:
    driver: local
  redis_data:
    driver: local
  prometheus_data:
    driver: local
  api_logs:
    driver: local
  worker_logs:
    driver: local
  nginx_logs:
    driver: local

networks:
  pfas-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16

---
# .env file template
POSTGRES_PASSWORD=pfas_secure_db_password_2024
MONGO_PASSWORD=mongo_secure_password_2024
REDIS_PASSWORD=redis_secure_password_2024
JWT_SECRET_KEY=your_jwt_secret_key_here
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
EPA_COMPTOX_API_KEY=your_epa_api_key

---
# nginx/nginx.conf - Production-ready reverse proxy
events {
    worker_connections 1024;
    use epoll;
    multi_accept on;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Logging
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                   '$status $body_bytes_sent "$http_referer" '
                   '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;
    error_log /var/log/nginx/error.log warn;

    # Performance optimizations
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss;

    # Rate limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=100r/m;
    limit_req_zone $binary_remote_addr zone=upload:10m rate=10r/m;

    # Upstream backend
    upstream pfas_api {
        server pfas-api:8000;
        keepalive 32;
    }

    server {
        listen 80;
        server_name _;
        
        # Security headers
        add_header X-Frame-Options DENY always;
        add_header X-Content-Type-Options nosniff always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Referrer-Policy strict-origin-when-cross-origin always;

        # Client max body size for compound uploads
        client_max_body_size 10M;

        # API endpoints
        location /api/ {
            limit_req zone=api burst=20 nodelay;
            
            proxy_pass http://pfas_api;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            
            proxy_connect_timeout 30s;
            proxy_send_timeout 60s;
            proxy_read_timeout 300s;  # Extended for long-running QSAR predictions
            
            proxy_buffering off;
            proxy_request_buffering off;
        }

        # Health check
        location /health {
            proxy_pass http://pfas_api/health;
            access_log off;
        }

        # Static files
        location /static/ {
            alias /usr/share/nginx/html/static/;
            expires 1y;
            add_header Cache-Control "public, immutable";
        }

        # Root
        location / {
            proxy_pass http://pfas_api;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}

---
# sql/init_db.sql - Database initialization
-- Create PFAS database schema
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Compounds table
CREATE TABLE pfas_compounds (
    id SERIAL PRIMARY KEY,
    dtxsid VARCHAR(50) UNIQUE,
    smiles TEXT NOT NULL,
    name VARCHAR(500),
    cas_number VARCHAR(20),
    molecular_weight FLOAT,
    pfas_category VARCHAR(50),
    chain_length INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Predictions table
CREATE TABLE toxicity_predictions (
    id SERIAL PRIMARY KEY,
    compound_id INTEGER REFERENCES pfas_compounds(id),
    endpoint VARCHAR(100) NOT NULL,
    prediction_value FLOAT,
    confidence_lower FLOAT,
    confidence_upper FLOAT,
    model_version VARCHAR(50),
    applicability_domain BOOLEAN,
    uncertainty_score FLOAT,
    regulatory_framework VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Jobs table for tracking background tasks
CREATE TABLE prediction_jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id VARCHAR(100),
    status VARCHAR(20) DEFAULT 'pending',
    compound_count INTEGER,
    endpoints TEXT[],
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    error_message TEXT
);

-- Indexes for performance
CREATE INDEX idx_compounds_dtxsid ON pfas_compounds(dtxsid);
CREATE INDEX idx_compounds_cas ON pfas_compounds(cas_number);
CREATE INDEX idx_predictions_compound ON toxicity_predictions(compound_id);
CREATE INDEX idx_predictions_endpoint ON toxicity_predictions(endpoint);
CREATE INDEX idx_jobs_user ON prediction_jobs(user_id);
CREATE INDEX idx_jobs_status ON prediction_jobs(status);

-- Grant permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO pfas_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO pfas_user;
