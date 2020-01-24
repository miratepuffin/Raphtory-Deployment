FROM bigtruedata/scala

RUN apt-get update -y && apt-get install build-essential -y && apt-get install tcl8.5 -y

RUN apt-get update && apt-get install -y dnsutils && ln -s /opt/docker/aspectjweaver /opt/aspectjweaver && apt-get install -y unzip

COPY blocks blocks

RUN apt-get install netcat -y

RUN apt-get install curl -y

RUN apt-get install less -y

RUN apt-get install vim -y

RUN echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list && curl https://www.apache.org/dist/cassandra/KEYS | apt-key add -

RUN apt-get update && apt-get install cassandra -y

RUN mkdir -p /var/lib/cassandra/data && chmod 777 /var/lib/cassandra/data && mkdir -p /var/lib/cassandra/commitlog && chmod 777 /var/lib/cassandra/commitlog && chmod 777 /var/lib/cassandra/ && mkdir -p /var/log/cassandra/ && chmod 777 /var/log/cassandra/

COPY gabNetwork500.csv gabNetwork500.csv

ENTRYPOINT ["/bin/bash"]
