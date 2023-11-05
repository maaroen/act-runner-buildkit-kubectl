FROM ghcr.io/catthehacker/ubuntu:act-latest
#ARG TARGETPLATFORM
#ARG ARCHITECTURE=amd64
#ENV ARCHITECTURE $ARCHITECTURE
ARG TARGETARCH
#RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then ARCHITECTURE=arm; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=arm64; else ARCHITECTURE=amd64; fi
RUN wget -q "https://github.com/moby/buildkit/releases/download/v0.10.6/buildkit-v0.10.6.linux-${TARGETARCH}.tar.gz" && mkdir buildkit && cat buildkit-v0.10.6.linux-${TARGETARCH}.tar.gz | tar -C buildkit -zxvf - && mv buildkit/bin/buildctl /usr/bin/buildctl && rm -rf buildkit

RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash && mv kustomize /usr/local/bin

 
