# Use the latest official Debian image as the base
FROM debian:bullseye-slim

# Install required dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    apt-transport-https \
    unzip \
    libnss3 \
    libgconf-2-4 \
    python3 \
    python3-pip \
    python3-setuptools && \
    rm -rf /var/lib/apt/lists/*

# Add the Google Chrome APT repository and install Chrome
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-linux-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux-keyring.gpg] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Check Chrome installation
RUN google-chrome-stable --version

# Install ChromeDriver
RUN CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    curl -sSL "https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip" -o chromedriver.zip && \
    unzip chromedriver.zip -d /usr/local/bin/ && \
    rm chromedriver.zip

# Set environment variables for Chrome and ChromeDriver
ENV CHROME_BIN=/usr/bin/google-chrome \
    CHROME_DRIVER=/usr/local/bin/chromedriver

# Set working directory
WORKDIR /app

# Copy Python dependencies and install them
COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

# Copy the test code
COPY . /app

# Run the test suite using unittest when the container starts
CMD ["python3", "-m", "unittest", "discover", "-s", "."]
