docker rm -f $(docker ps -a -q)
docker system prune -af
docker volume rm $(docker volume ls -q)
