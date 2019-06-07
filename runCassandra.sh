for i in $(cat cassandra.list | head -n 2); do
    docker node update --label-add raphtoryrole=cassandra $i
done

docker stack deploy --compose-file=cassandra.yml raphtoryCassandra
