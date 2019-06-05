#!/bin/bash


function clean_labels() {
    for i in $(cat nodes.list | head -n 14); do
        docker node update --label-rm raphtoryrole $i
    done
}

function deploy {
    docker stack deploy raphtory --compose-file docker-compose-seperate.yml
}

function deployPrometheus {
  cp EnvExamples/archivist_dotenv.example .env
  docker stack deploy raphtory-prometheus --compose-file docker-compose-prometheus.yml
}

function poll() {
    python jsonparser.py
}

function remove() {
    rm -rf .env
    docker stack remove raphtory
    echo "Pruning cluster"
    ssh root@studoop './docker-scripts/prune.sh' >  /dev/null
    echo "Pruning complete"
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
    cp EnvExamples/archivist_dotenv.example .env

    for i in $(cat routers.list | head -n 4); do
        docker node update --label-add raphtoryrole=router $i
    done


    for i in $(cat pm.list | head -n $1); do
        docker node update --label-add raphtoryrole=partitionManager $i
    done

    docker node update --label-add raphtoryrole=setupjobs moon15

    echo "PARTITION_MIN=$1" >> .env
    echo "ROUTER_MIN=4" >> .env
    echo "UPDATES_FREQ=$2" >> .env
    echo "ENTITY_POOL=$3" >> .env
    echo "ARCHIVING=$4" >> .env
    echo "COMPRESSING=$5" >> .env
    echo "SAVING=$6" >> .env
}

function run() {
    date
    echo "$1 PM/R"
    clean_labels
    setup_workers $1 $2 $3 $4 $5 $6
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
  run $1 5000 1000000 false false false 1
  run $1 5000 1000000 false false false 2
  run $1 5000 1000000 false false false 3
  run $1 5000 1000000 false false false 4
  run $1 5000 1000000 false false false 5
  run $1 5000 1000000 true false false 1
  run $1 5000 1000000 true false false 2
  run $1 5000 1000000 true false false 3
  run $1 5000 1000000 true false false 4
  run $1 5000 1000000 true false false 5
  run $1 5000 1000000 true true false 1
  run $1 5000 1000000 true true false 2
  run $1 5000 1000000 true true false 3
  run $1 5000 1000000 true true false 4
  run $1 5000 1000000 true true false 5
  run $1 5000 1000000 true true true 1
  run $1 5000 1000000 true true true 2
  run $1 5000 1000000 true true true 3
  run $1 5000 1000000 true true true 4
  run $1 5000 1000000 true true true 5
}

deployPrometheus
grouprun 1
grouprun 2
grouprun 4
grouprun 8
grouprun 10
