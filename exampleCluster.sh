#!/bin/bash


function clean_labels() { #Clears the docker labels off of every node
    for i in $(cat nodelists/nodes.list); do
        docker node update --label-rm raphtoryrole $i
    done
}

function deploy { # deploys the raphtory stack as specified in cluster.yml
    docker stack deploy raphtory --compose-file cluster.yml
}

function deployPrometheus { #deploys prometheus which monitors raphtory
  for i in $(cat nodelists/prometheus.list); do #does the same but for partition managers
      docker node update --label-add raphtoryrole=prometheus $i
  done
  cp EnvExamples/gabgraph_dotenv.example .env
  docker stack deploy raphtory-prometheus --compose-file prometheus.yml
}

function remove() { #removes the old cluster if there was one
    rm -rf .env
    docker stack remove raphtory
}

function setup_workers() { #gets the selected docker swarm nodes ready for the raphtory stack
    cp EnvExamples/readme_dotenv.example .env #creates a .env file from one of the exmaples, in this case the one for the readme

    for i in $(cat nodelists/routers.list); do # labels all of the requested router nodes so that the deployment knows who to setup on
        docker node update --label-add raphtoryrole=router $i
    done

    for i in $(cat nodelists/pm.list); do #does the same but for partition managers
        docker node update --label-add raphtoryrole=partitionManager $i
    done

    for i in $(cat nodelists/setup.list); do #again for the misc containers
        docker node update --label-add raphtoryrole=setupjobs $i
    done

    echo "PARTITION_MIN=$1" >> .env #used to inform raphtory of how many partition managers there are for distribution of data
    echo "ROUTER_MIN=$2" >> .env
}

function run() {
    date
    clean_labels
    pm="$(wc -l nodelists/pm.list | awk '{print $1}')"
    router="$(wc -l nodelists/routers.list | awk '{print $1}')"
    setup_workers pm router $1
    deploy
}

remove
deployPrometheus
run
