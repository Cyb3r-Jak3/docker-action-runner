FROM ubuntu:focal

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y jq curl tar liblttng-ust0 libkrb5-3 zlib1g && \
    rm -rf /var/lib/apt/lists/*

COPY ./setup.sh pre-reqs.sh /
ENV RUNNER_ALLOW_RUNASROOT=true
RUN /pre-reqs.sh
CMD /setup.sh; /runner/run.sh