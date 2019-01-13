## ----- TARGETS ------
## Generic:
.PHONY: default help
default: repo-index

## Show usage for the targets in this Makefile.
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	   awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'


## Helm Repo:
.PHONY: repo-index
repo-index: ## Index the Helm repo.
	@echo "Indexing Helm repo..." && helm repo index . && echo done
