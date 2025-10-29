FROM python:3.13-slim

# Set environment variables
ENV ACCEPT_EULA=Y \
    PATH="/usr/bin:${PATH}" \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app

# Install system dependencies and ODBC driver
RUN apt-get update && apt-get install -y \
    curl gnupg apt-transport-https ca-certificates \
    unixodbc unixodbc-dev odbcinst && \
    curl -O https://packages.microsoft.com/debian/12/prod/pool/main/m/msodbcsql18/msodbcsql18_18.5.1.1-1_amd64.deb && \
    mkdir -p /opt/microsoft/msodbcsql18 && \
    touch /opt/microsoft/msodbcsql18/ACCEPT_EULA && \
    dpkg -i msodbcsql18_18.5.1.1-1_amd64.deb && \
    rm msodbcsql18_18.5.1.1-1_amd64.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python dependencies including pyodbc
COPY app/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt && \
    pip install --no-cache-dir pyodbc

# Copy application code
COPY . /app

# Set working directory to the app folder
WORKDIR /app/app

# Expose port and run Streamlit app
EXPOSE 3000
ENTRYPOINT ["streamlit", "run", "Home.py", "--server.port=3000", "--server.address=0.0.0.0"]