#!/bin/bash

function remove() {
    docker stack remove raphtory
}

function deploy {
    docker stack deploy raphtory --compose-file docker-compose.yml
}

function poll() {
    python jsonparser.py
    return $?
}

function poll_loop() {
    while poll; do
        sleep 10
    done
}

function clean_labels() {
    for i in $(cat nodes.list | head -n 14); do
        docker node update --label-rm raphtoryrole $i
    done
}

function setup_workers() {
    for i in $(cat routers.list | head -n $1); do
        docker node update --label-add raphtoryrole=router $i
    done

    for i in $(cat pm.list | head -n $1); do
        docker node update --label-add raphtoryrole=partitionManager $i
    done

    echo "PARTITION_MIN=$1" >> .env
    echo "ROUTER_MIN=$1" >> .env
    echo "UPDATES_FREQ=$2" >> .env
    echo "WINDOW_SIZE=$3" >> .env
    echo "ENTITY_POOL=$4" >> .env
    echo "ROUTERCLASS=$5" >> .env
}

function run() {
    date
    echo "$1 PM/R"
    clean_labels
    setup_workers $1 $2 $3
    deploy
    sleep 180
    poll_loop
    date
    remove
    sleep 180
}

rm -rf .env
remove
cp EnvExamples/windowing_dotenv.example .env
run 4 5000 300 10000 com.raphtory.examples.random.actors.RandomRouter
rm -rf .env
