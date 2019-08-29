# == Variables ==
# Program version.
__TAG = $(shell git describe --tags 2> /dev/null)
ifneq ($(__TAG),)
	VERSION ?= $(shell echo "$(__TAG)" | cut -c 2-)
else
	VERSION ?= undefined
endif


# == Targets ==
# Generic:
.PHONY: default version setup install build clean run lint test review help
__ARGS = $(filter-out $@,$(MAKECMDGOALS))

default: build
version: # Show project version (derived from 'git describe').
	@echo $(VERSION)

__noop:
	@echo "Nothing to do." >&2 && exit 1

setup: __noop # Set this project up on a new environment.
install: __noop # Install project dependencies.

run: __noop # Run project (development).
build: # Build project.
	@$(MAKE) charts-package -- $(__ARGS)
clean: # Clean build artifacts.
	@$(MAKE) charts-clean -- $(__ARGS)

lint:  # Lint and check code.
	@$(MAKE) charts-lint -- $(__ARGS)

test: __noop # Run tests.
review: __noop # Lint code and run tests.

# Show usage for the targets in this Makefile.
help:
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | \
	 awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'


# Helm charts:
.PHONY: charts-lint charts-package charts-clean

__CDIRS = $(shell \
	unset vcdirs && \
	for cdir in $$(ls -l | egrep '^d' | awk '{print $$NF}'); do \
	  if [ -s "$$cdir/Chart.yaml" ]; then \
	    vcdirs="$$vcdirs $$cdir"; \
	  fi; \
	done && \
	echo "$$vcdirs")

charts-lint:
	@echo "Linting charts with Helm..." && \
	 for cdir in $(__CDIRS); do helm lint $$cdir $(__ARGS); done && \
	 echo done

charts-package: ## Package charts into release archives.
	@$(MAKE) charts-lint && \
	 echo "Packaging charts..." && \
	 if [ -d dist ]; then rm -rf dist; fi && \
	 mkdir dist && \
	 CHARTS="$(__CDIRS)" && \
	 if [ -n $(__ARGS) ]; then CHARTS="$(__ARGS)"; fi && \
	 for chart in "$$CHARTS"; do \
	   helm package -d dist "$$chart" $(__ARGS); \
	 done && \
	 echo done

charts-clean:
	@echo "Cleaning up chart packages..." && \
	 rm -rf dist && \
	 echo done


# == Hacks ==
# These targets are hacks that allow for Make targets to receive
# pseudo-arguments.
.PHONY: __FORCE
__FORCE:
%: __FORCE
	@:
