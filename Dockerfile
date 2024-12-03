# Base image with Python 3.10
FROM python:3.10-slim

# Set environment variables to prevent Python from generating .pyc files and ensure stdout/stderr logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmour -o /usr/share/keyrings/chrome-keyring.gpg \
    && sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list' \
    && apt-get update && apt-get install -y google-chrome-stable \
    && CHROME_VERSION=$(google-chrome --version | grep -oP "\d+\.\d+\.\d+\.\d+") \
    && echo "Chrome version being downloaded: $CHROME_VERSION" \
    && wget "https://storage.googleapis.com/chrome-for-testing-public/$CHROME_VERSION/linux64/chromedriver-linux64.zip" -O chromedriver-linux64.zip \
    && unzip chromedriver-linux64.zip -d /opt/chromedriver \
    && chmod +x /opt/chromedriver/chromedriver-linux64/chromedriver \
    && ln -s /opt/chromedriver/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver

WORKDIR /usr/src/app

ENV CHROME_BIN=/usr/bin/google-chrome
ENV CHROME_DRIVER=/usr/local/bin/chromedriver

COPY . .

# Install Python dependencies
RUN pip install pipenv && pipenv install

CMD ["pipenv", "run", "robot", "tasks/main.robot"]