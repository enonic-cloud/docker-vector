FROM timberio/vector:0.20.0-alpine

RUN apk add --no-cache curl

COPY scripts/xp_metrics /usr/local/bin/xp_metrics
COPY config /etc/vector

ENV VECTOR_CONFIG_DIR /etc/vector/*
ENV VECTOR_WATCH_CONFIG /etc/vector