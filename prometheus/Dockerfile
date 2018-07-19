FROM prom/prometheus:latest
COPY ./env-setter.sh /usr/local/bin/
ADD ./prometheus.yml /etc/prometheus/prometheus.yml
USER root
RUN chmod 777 -R /etc/prometheus/prometheus.yml
ENTRYPOINT [ "sh", "/usr/local/bin/env-setter.sh" ]
CMD        [ "" ]

