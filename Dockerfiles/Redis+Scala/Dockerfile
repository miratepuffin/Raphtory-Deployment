FROM adoptopenjdk:14-hotspot-bionic

RUN apt-get update -y && apt-get install build-essential -y && apt-get install tcl8.5 -y

RUN apt install -y iproute2

RUN apt-get install wget

RUN apt-get update && apt-get install -y dnsutils && ln -s /opt/docker/aspectjweaver /opt/aspectjweaver && apt-get install -y unzip

RUN apt-get install netcat -y && apt-get install curl -y && apt-get install less -y && apt-get install vim -y && apt-get install net-tools -y && apt-get install lsof -y && apt-get install traceroute -y

RUN wget https://download-gcdn.ej-technologies.com/jprofiler/jprofiler_linux_11_1_3.tar.gz -P /tmp/ &&\
 tar -xzf /tmp/jprofiler_linux_11_1_3.tar.gz -C /usr/local &&\
 rm /tmp/jprofiler_linux_11_1_3.tar.gz

ENV JPAGENT_PATH="-agentpath:/usr/local/jprofiler11.1.3/bin/linux-x64/libjprofilerti.so=nowait"
EXPOSE 8849

COPY gabNetwork500.csv gabNetwork500.csv

COPY profiler.sh profiler.sh

RUN wget https://downloads.typesafe.com/scala/2.13.3/scala-2.13.3.tgz
RUN mkdir /usr/share/scala
RUN tar -zxvf scala-2.13.3.tgz -C /usr/share/scala

RUN chown -R root:root /usr/share/scala && \
  chmod -R 755 /usr/share/scala && \
  ln -s /usr/share/scala/bin/scala /usr/local/bin/scala


Run mkdir /app && chmod 777 /app

COPY gabNetwork500.csv /app/gabNetwork500.csv

ENTRYPOINT ["/bin/bash"]
