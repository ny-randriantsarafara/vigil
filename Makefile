COMPOSE = docker compose

.PHONY: up
up: ## Start observability stack
	$(COMPOSE) up -d

.PHONY: down
down: ## Stop observability stack
	$(COMPOSE) down

.PHONY: restart
restart: down up ## Restart observability stack

.PHONY: logs
logs: ## Tail all stack logs
	$(COMPOSE) logs -f

.PHONY: ps
ps: ## Show running services
	$(COMPOSE) ps

.PHONY: clean
clean: ## Stop stack and remove volumes
	$(COMPOSE) down -v

.PHONY: validate
validate: ## Validate compose and YAML files
	./scripts/validate.sh

.PHONY: smoke
smoke: ## Check runtime health endpoints
	./scripts/smoke.sh

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
