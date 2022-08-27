.PHONY: help # Ref: https://www.freecodecamp.org/news/self-documenting-makefile/
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'


.PHONY: create deploy expand undeploy delete

create: ## Create IKS Cluster
	@python3 iks_cluster_create.py

deploy: ## Deploy IKS Cluster
	@python3 iks_cluster_deploy.py

expand: ## Expand IKS Cluster
	@python3 iks_cluster_expand.py

undeploy: ## Undeploy IKS Cluster
	@python3 iks_cluster_undeploy.py

delete: ## Delete IKS Cluster
	@python3 iks_cluster_delete.py
