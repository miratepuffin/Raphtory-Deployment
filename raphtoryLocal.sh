
function deploy {
    docker-compose -f compose/singlenode.yml up --remove-orphans
}

function setup_live() {
    cp EnvExamples/readme_singlenode_dotenv.example .env
    echo "LAMTYPE=$1" >> .env
    echo "LAMCLASS=com.raphtory.core.analysis.Algorithms.$2" >> .env
    echo "WINDOWTYPE=$3" >>.env
    echo "WINDOWSET=$4" >>.env
    echo "WINDOW=$4" >> .env
    echo "GAB_PROJECT_OUTPUT=/opt/docker/bin/readme.json" >> .env
}

function setup_view() {
    cp EnvExamples/readme_singlenode_dotenv.example .env
    echo "LAMTYPE=$1" >> .env
    echo "LAMCLASS=com.raphtory.core.analysis.Algorithms.$2" >> .env
    echo "TIMESTAMP=$3" >> .env
    echo "WINDOWTYPE=$4" >>.env
    echo "WINDOWSET=$5" >>.env
    echo "WINDOW=$5" >> .env
    echo "GAB_PROJECT_OUTPUT=/opt/docker/bin/readme.json" >> .env
}

function setup_range() {
    cp EnvExamples/readme_singlenode_dotenv.example .env
    echo "LAMTYPE=$1" >> .env
    echo "LAMCLASS=com.raphtory.core.analysis.Algorithms.$2" >> .env
    echo "START=$3" >> .env
    echo "END=$4" >> .env
    echo "JUMP=$5" >> .env
    echo "WINDOWTYPE=$6" >>.env
    echo "WINDOWSET=$7" >>.env
    echo "WINDOW=$7" >> .env
    echo "GAB_PROJECT_OUTPUT=/opt/docker/bin/readme.json" >> .env
}

if [ $1 = "Live" ]
then
  setup_live $1 $2 $3 $4
  deploy
fi

if [ $1 = "View" ]
then
  setup_view $1 $2 $3 $4 $5
  deploy
fi

if [ $1 = "Range" ]
then
  setup_range $1 $2 $3 $4 $5 $6 $7
  deploy
fi

#./raphtoryLocal Range ConnectedComponents 1470783600000 1476114624000 86400000 false 86400000
# This will run a range query between august and october doing connected componnents every day with no windowing enabled
