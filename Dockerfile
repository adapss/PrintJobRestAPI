FROM python:3.13-slim

# Install dependencies including missing ones for Chrome
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    curl \
    unzip \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libx11-xcb1 \
    libdrm2 \
    libgbm1 \
    libxshmfence1 \
    libxcomposite1 \
    libxcursor1 \
    libxi6 \
    libxtst6 \
    libxrandr2 \
    libgl1 \
    libvulkan1 \
    xdg-utils \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Install Google Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

# Install Chromedriver (compatible with installed Chrome)
# RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d '.' -f 1) && \
#    CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION}") && \
#    wget -q "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" && \
#    unzip chromedriver_linux64.zip && \
#    mv chromedriver /usr/bin/chromedriver && \
#    chmod +x /usr/bin/chromedriver && \
#    rm chromedriver_linux64.zip

COPY app/drivers/chromedriver  /usr/bin/chromedriver
RUN chmod +x /usr/bin/chromedriver

# Set environment variables
ENV PATH="/usr/bin:${PATH}"

# Install Python dependencies
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your app code
COPY . /app
WORKDIR /app

# Expose port and run the app
EXPOSE 3000
ENTRYPOINT ["streamlit", "run", "app/Home.py", "--server.port=3000", "--server.address=0.0.0.0"]

