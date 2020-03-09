FROM swipl:8.0.3

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        python3; \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/map/"]
ENTRYPOINT ["swipl", "-q", "-t", "halt", "-l", "main.pl"]
CMD ["-f", "/map/map.txt", "-g", "main"]
COPY . .
