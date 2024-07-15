.SILENT:
SHELL = bash

.env:
	echo "Create env from template"
	DB_P=`openssl rand -hex 8` envsubst < tpl.env | op inject -f > .env

env: .env

up: .env
	echo "Powering up"
	docker compose up -d

logs:
	docker compose logs -f

down:
	echo "Powering down"
	docker compose down

clean:
	echo "Powering down and removing volumes"
	docker compose down -v
	rm -rf .env

.PHONY:	up env logs down clean 
