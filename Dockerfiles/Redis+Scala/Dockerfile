FROM bigtruedata/scala

RUN apt-get update -y && apt-get install build-essential -y && apt-get install tcl8.5 -y

RUN apt-get update && apt-get install -y dnsutils && ln -s /opt/docker/aspectjweaver /opt/aspectjweaver && apt-get install -y unzip

RUN apt-get install netcat -y && apt-get install curl -y && apt-get install less -y && apt-get install vim -y && apt-get install net-tools -y && apt-get install lsof -y && apt-get install traceroute -y

COPY gabNetwork500.csv gabNetwork500.csv

ENTRYPOINT ["/bin/bash"]
