# hadolint ignore=DL3007
FROM myoung34/github-runner-base:latest
LABEL maintainer="adascalitei.victor@gmail.com"

# Add kubernetes
RUN curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl \
    && sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

ENV AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
RUN mkdir -p /opt/hostedtoolcache

ARG GH_RUNNER_VERSION="2.277.1"
ARG TARGETPLATFORM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /actions-runner
COPY install_actions.sh /actions-runner

RUN chmod +x /actions-runner/install_actions.sh \
  && /actions-runner/install_actions.sh ${GH_RUNNER_VERSION} ${TARGETPLATFORM} \
  && rm /actions-runner/install_actions.sh

COPY token.sh entrypoint.sh /
RUN chmod +x /token.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
