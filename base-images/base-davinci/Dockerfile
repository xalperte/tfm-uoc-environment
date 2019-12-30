FROM xalperte/base-caravaggio:0.1

# CHROMIUM configuration
ENV CHROMIUM_BIN_FILE="/usr/bin/chromium"

# Install all the dependencies
RUN apt-get update && \
    apt-get install -y \
        xvfb \
        tinywm \
        fonts-ipafont-gothic xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic \
        chromium

# Install Chrome WebDriver
RUN CHROMEDRIVER_VERSION="78.0.3904.105" && \
    mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver
