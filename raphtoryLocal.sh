
function deploy {
    docker-compose -f singlenode.yml up --remove-orphans
}

function setup_workers() {
    cp EnvExamples/readme_singlenode_dotenv.example .env
    echo "LAMTYPE=$1" >> .env
    echo "LAMCLASS=com.raphtory.core.analysis.Algorithms.$2" >> .env
    echo "START=$3" >> .env
    echo "END=$4" >> .env
    echo "JUMP=$5" >> .env
    echo "WINDOWTYPE=$6" >>.env
    echo "WINDOW=$7" >> .env
    echo "GAB_PROJECT_OUTPUT=/opt/docker/bin/readme.json" >> .env
}

setup_workers $1 $2 $3 $4 $5 $6 $7
deploy


#./raphtoryLocal Range ConnectedComponents 1470783600000 1476114624000 86400000 false 86400000
# This will run a range query between august and october doing connected componnents every day with no windowing enabled
