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
    for i in $(cat nodes.list | head -n $1); do
        docker node update --label-add raphtoryrole=mainjobs $i
    done
    echo "PARTITION_MIN=$1" >> .env
    echo "ROUTER_MIN=$1" >> .env
    echo "UPDATES_FREQ=$2" >> .env

}

function run() {
    rm -rf .env
    cp EnvExamples/gab_automated_dotenv.example .env
    date
    echo "$1 PM/R"
    clean_labels
    setup_workers $1 $2
    deploy
    sleep 600
    poll_loop
    date
    remove
    sleep 180
}
#poll_loop
remove
run 14 1000
#run 8 2000
#run 8 4000
#run 8 8000
#run 8 16000
#run 8 32000
#run 8 64000
#run 8 128000
