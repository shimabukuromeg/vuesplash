.DEFAULT_GOAL := help

build: ## build develoment environment with laradock
	if ! [ -f .env ];then cp .env.example .env;fi
	docker-compose build
	docker-compose run --rm php-cli composer install
	docker-compose run --rm php-cli php artisan key:generate
	docker-compose run --rm yarn install
	docker-compose run --rm yarn run dev

serve: ## Run Server
	docker-compose up -d nginx
	docker-compose up php

art: ## Show artisan commands
	docker-compose run --rm php-cli php artisan

tinker: ## Run tinker
	docker-compose run --rm php-cli php artisan tinker

route: ## Run route:list
	docker-compose run --rm php-cli php artisan route:list

migrate: ## Run migrate
	docker-compose run --rm php-cli php artisan migrate

rollback: ## Run migrate:rollback
	docker-compose run --rm php-cli php artisan migrate:rollback

migrate-status: ## Run migrate:rollback
	docker-compose run --rm php-cli php artisan migrate:status

composer: ## Entry for Composer command
	docker-compose run --rm php-cli composer install

ide-helper: ## Make ide-helper files
	docker-compose run --rm php-cli php artisan ide-helper:generate
	docker-compose run --rm php-cli php artisan ide-helper:models -N
	docker-compose run --rm php-cli php artisan ide-helper:meta

db-setup: ## Setup DB data
	docker-compose up -d db
	docker-compose run --rm php-cli php artisan migrate:install
	docker-compose run --rm php-cli php artisan migrate
	docker-compose run --rm php-cli php artisan db:seed

db-remove: ## Remove DB volume
	docker-compose stop db
	docker-compose down
	docker volume rm touchpoint_mysql-volume

yarn-install: ## Run yarn install
	docker-compose run --rm yarn install

yarn-dev: ## Entry for yarn command
	docker-compose run --rm yarn run dev

yarn-watch: ## Run yarn watch
	docker-compose run --rm yarn run watch

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
