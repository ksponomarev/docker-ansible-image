FROM ubuntu:bionic AS collector

ARG HELM=v3.1.2

RUN apt update -qq;\
    apt install curl apt-transport-https git -y wget apt-utils gnupg2 zip unzip ca-certificates;

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl;\
    mv kubectl /usr/local/bin/;
RUN wget https://get.helm.sh/helm-${HELM}-linux-amd64.tar.gz;\
    tar -zxf helm-${HELM}-linux-amd64.tar.gz;\
    mv linux-amd64/helm /usr/local/bin/helm;
RUN chmod +x /usr/local/bin/*

FROM ubuntu:bionic
COPY --from=collector /usr/local/bin/ /usr/local/bin/
COPY . /ansible
WORKDIR /ansible
RUN set -ex; apt update -qq; apt install -y --no-install-recommends software-properties-common; apt-add-repository --yes --update ppa:ansible/ansible;\
    apt install ansible -y