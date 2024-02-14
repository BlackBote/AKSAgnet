FROM ubuntu:20.04
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
 && apt-get install -y sudo


RUN wget https://github.com/Azure/kubelogin/releases/download/v0.0.28/kubelogin-linux-amd64.zip --no-check-certificate
RUN sudo apt-get install zip unzip
RUN unzip kubelogin-linux-amd64.zip
RUN sudo mv bin/linux_amd64/kubelogin /usr/bin

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common

RUN curl -kv -LO https://dl.k8s.io/release/v1.27.0/bin/linux/amd64/kubectl | bash \ 
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash


RUN apt-get update -y
RUN sudo apt-get install wget apt-transport-https gnupg lsb-release -y
RUN wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | (OUT=$(sudo apt-key add - 2>&1) || echo $OUT) 
RUN echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
RUN sudo apt-get update -y
RUN sudo apt-get install trivy


# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh 

ENTRYPOINT [ "./start.sh" ]
