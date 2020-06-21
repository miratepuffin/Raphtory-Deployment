#!/bin/bash


function clean_labels() {
    for i in $(cat nodelists/awsnodes | head -n 14); do
        docker node update --label-rm raphtoryrole $i
    done
}

function deploy {
    docker stack deploy raphtory --compose-file cluster.yml
}

function deployPrometheus {
  docker stack deploy raphtory-prometheus --compose-file prometheusGrafana.yml
}

function poll() {
    python jsonparser.py
}

function remove() {
    rm -rf .env
    docker stack remove raphtory
}

function serviceLog() {
  if [ ! -d logs ]; then mkdir logs; fi
  name="$1_$2_$3_$4_$5"
  echo $name
  mkdir "logs/$name"
  docker service logs raphtory_updater > "logs/$name/updater"
  docker service logs raphtory_router > "logs/$name/router"
  docker service logs raphtory_watchDog > "logs/$name/watchDog"
  docker service logs raphtory_seedNode > "logs/$name/seedNode"
  docker service logs raphtory_partitionManager > "logs/$name/partitionManager"
}


function setup_workers() {
    for i in $(cat nodelists/routers.list | head -n 1); do
        docker node update --label-add raphtoryrole=router $i
    done

    for i in $(cat nodelists/pm.list | head -n $1); do
        docker node update --label-add raphtoryrole=partitionManager $i
    done

    echo "PARTITION_MIN=$1" >> .env
    echo "ROUTER_MIN=1" >> .env
}

function run() {
    date
    echo "$1 PM/R"
    clean_labels
    setup_workers $1
    deploy
    sleep 180
    poll
    date
    echo "Removing cluster in 30 seconds as dead letters > 500"
    serviceLog $1 $4 $5 $6 $7 time
    sleep 30
    remove
    sleep 180
}

remove

function grouprun() {
  run $1
  run $1
  run $1
}

deployPrometheus
grouprun 1
