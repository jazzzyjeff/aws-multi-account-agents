FROM --platform=linux/amd64 ubuntu:24.04
ENV TARGETARCH="linux-x64"

RUN apt update && \
  apt upgrade -y && \
  apt install -y curl git jq libicu74 unzip

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install AWS CLI v2
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Create agent user and set up home directory
RUN useradd -m -d /home/agent agent && \
    chown -R agent:agent /azp /home/agent

USER agent

ENTRYPOINT ["./start.sh"]
