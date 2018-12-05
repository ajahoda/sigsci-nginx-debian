FROM debian:9

# Initial setup
RUN apt-get update
RUN apt-get install -y apt-transport-https wget sed curl gnupg

# Add the signal sciences repo to our apt sources
RUN wget -qO - https://apt.signalsciences.net/gpg.key | apt-key add -
RUN echo "deb https://apt.signalsciences.net/release/debian/ jessie main" > /etc/apt/sources.list.d/sigsci-release.list
RUN apt-get update

# Install nginx + Lua
RUN apt-get -y install nginx-extras

# Install the sigsci agent
RUN apt-get -y install sigsci-agent
# Install the sigsci module
RUN apt-get -y install sigsci-module-nginx

# Configure nginx.conf and basic html
COPY app/nginx.conf /etc/nginx/nginx.conf
COPY app/default.conf /etc/nginx/sites-enabled/default.conf
COPY app/index.html /usr/share/nginx/html/index.html

# Configure Signal Sciences
RUN  mkdir /app && mkdir /etc/sigsci
COPY contrib/agent.conf /etc/sigsci/agent.conf

# Configure start script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENTRYPOINT ["/app/start.sh"]
