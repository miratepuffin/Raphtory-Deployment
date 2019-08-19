#!/bin/bash


function deploy {
    docker stack deploy analysis --compose-file AnalysisManager.yml
}

function serviceLog() {
  if [ ! -d logs ]; then mkdir logs; fi
  mkdir "logs/$name"
  docker service logs analysis_lam > "logs/analysis"
}


function setup_workers() {
    cp EnvExamples/gabgraph_dotenv.example .env
    echo "PARTITION_MIN=$1" >> .env
    echo "ROUTER_MIN=4" >> .env
    echo "GAB_PROJECT_OUTPUT=/opt/docker/bin/defout.csv" >> .env
    echo "LAMTYPE=$2" >> .env
    echo "LAMCLASS=com.raphtory.core.analysis.Algorithms.$3" >> .env
    echo "START=$4" >> .env
    echo "END=$5" >> .env
    echo "JUMP=$6" >> .env
    echo "WINDOW=$7" >> .env
    echo "ARCHIVING=False" >> .env

}

function run() {
    setup_workers 8 $1 $2 $3 $4 $5 $6
    deploy
}

#run WAM ConnectedComponents.ConComLAM 1470801546000 1471459626000 3600000 86400000
run WAM Density.DensityWAM 1470801546000 1471891600000 3600000 3600000
