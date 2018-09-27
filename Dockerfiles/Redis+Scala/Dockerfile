FROM bigtruedata/scala

RUN apt-get update -y && apt-get install build-essential -y && apt-get install tcl8.5 -y
RUN wget http://download.redis.io/releases/redis-stable.tar.gz && tar xzf redis-stable.tar.gz && cd redis-stable && make && make test && make install && cd utils && ./install_server.sh && update-rc.d redis_6379 defaults

RUN apt-get update && apt-get install -y dnsutils && ln -s /opt/docker/aspectjweaver /opt/aspectjweaver && apt-get install -y unzip

COPY blocks blocks

RUN apt-get install netcat -y

RUN apt-get install curl -y

RUN echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list && curl https://www.apache.org/dist/cassandra/KEYS | apt-key add -

RUN apt-get update && apt-get install cassandra -y


ENTRYPOINT ["/bin/bash"]
