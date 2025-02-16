start:
	podman-compose -f ./compose.yaml up -d
dbshell:
	podman-compose exec db psql plants_dev postgres
