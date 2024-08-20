FROM ghcr.io/catthehacker/ubuntu:act-latest
ARG TARGETARCH
RUN wget -q "https://github.com/moby/buildkit/releases/download/v0.15.2/buildkit-v0.15.2.linux-${TARGETARCH}.tar.gz" && mkdir buildkit && cat buildkit-v0.15.2.linux-${TARGETARCH}.tar.gz | tar -C buildkit -zxvf - && mv buildkit/bin/buildctl /usr/bin/buildctl && rm -rf buildkit

RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash && mv kustomize /usr/local/bin

# Install Docker-ce-cli
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - ;\
    add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" ;\
    DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends docker-ce-cli docker-buildx-plugin iproute2 \
    && DEBIAN_FRONTEND=noninteractive apt-get clean

RUN docker buildx create --name remote-buildkit --use --bootstrap --driver remote tcp://localhost:1234
