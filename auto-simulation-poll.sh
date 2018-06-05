#!/bin/bash

alias remove="docker stack remove raphtory"
alias deploy="docker stack deploy raphtory --compose-file docker-compose.yml"

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
}

function run() {
    date
    echo "$1 PM/R"
    clean_labels
    setup_workers $1
    deploy
    sleep 180
    poll_loop
    date
    remove
    sleep 180
}

rm -rf .env
cp .env.random .env
run 2
run 4
run 8
run 14
rm -rf .env
cp .env.gab .env
run 14

