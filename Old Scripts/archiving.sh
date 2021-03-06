#!/bin/bash


function clean_labels() {
    for i in $(cat nodes.list | head -n 14); do
        docker node update --label-rm raphtoryrole $i
    done
}

function deploy {
    docker stack deploy raphtory --compose-file docker-compose.yml
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
  name="$1_$2_$3_$4"
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

    for i in $(cat nodes.list | head -n $1); do
        docker node update --label-add raphtoryrole=mainjob $i
    done

    docker node update --label-add raphtoryrole=setupjobs moon14.eecs.qmul.ac.uk

    echo "PARTITION_MIN=$1" >> .env
    echo "ROUTER_MIN=$1" >> .env
    echo "UPDATES_FREQ=$2" >> .env
    echo "ENTITY_POOL=$3" >> .env
    echo "COMPRESSING=$4" >> .env
    echo "SAVING=$5" >> .env
}

function run() {
    date
    echo "$1 PM/R"
    clean_labels
    setup_workers $1 $2 $3 $4 $5
    deploy
    sleep 180
    poll
    date
    echo "Removing cluster in 30 seconds as dead letters > 500"
    serviceLog $1 $4 $5 time
    sleep 30
    remove
    sleep 180
}

remove
run 1 1000 1000000 true true
run 1 1000 1000000 false false
run 1 1000 1000000 true false

run 2 1000 1000000 false false
run 2 1000 1000000 true false
run 2 1000 1000000 true true

run 4 1000 1000000 false false
run 4 1000 1000000 true false
run 4 1000 1000000 true true

run 8 1000 1000000 false false
run 8 1000 1000000 true false
run 8 1000 1000000 true true

run 12 1000 1000000 false false
run 12 1000 1000000 true false
run 12 1000 1000000 true true
