#!/bin/bash


function deploy {
    docker stack deploy analysis --compose-file exampleAnalysis.yml
}

function setup_workers() {
    cp EnvExamples/gabgraph_dotenv.example .env
    echo "LAMTYPE=$1" >> .env
    echo "LAMCLASS=com.raphtory.core.analysis.Algorithms.$2" >> .env
    echo "START=$3" >> .env
    echo "END=$4" >> .env
    echo "JUMP=$5" >> .env
    echo "WINDOWTYPE=$6" >>.env
    echo "WINDOW=$7" >> .env
}

setup_workers $1 $2 $3 $4 $5 $6 $7
deploy


#Range ConnectedComponents 1470783600000 1476114624000 86400000 false 86400000
