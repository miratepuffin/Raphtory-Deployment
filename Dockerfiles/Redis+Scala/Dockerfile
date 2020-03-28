FROM bigtruedata/scala

RUN apt-get update -y && apt-get install build-essential -y && apt-get install tcl8.5 -y

RUN apt-get update && apt-get install -y dnsutils && ln -s /opt/docker/aspectjweaver /opt/aspectjweaver && apt-get install -y unzip

COPY blocks blocks

RUN apt-get install netcat -y

RUN apt-get install curl -y

RUN apt-get install less -y

RUN apt-get install vim -y

RUN apt-get install net-tools -y

RUN apt-get install lsof -y

COPY gabNetwork500.csv gabNetwork500.csv

ENTRYPOINT ["/bin/bash"]
