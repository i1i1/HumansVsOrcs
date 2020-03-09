FROM swipl:8.0.3

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        python3; \
    rm -rf /var/lib/apt/lists/*

COPY . .
VOLUME ["/map/"]
CMD [ \
    "/usr/bin/swipl", \
    "-q", \
    "-f", "/map/map.txt", \
    "-l", "main.pl", \
    "-g", "main", \
    "-t", "halt" \
]
