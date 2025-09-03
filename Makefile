#!/usr/bin/env -S make -f

MAKEFLAGS += --warn-undefined-variable
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --silent

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.DEFAULT_GOAL := help

help: Makefile  ## Show help
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'


# =============================================================================
# Common
# =============================================================================
install:  ## Install deps
	git submodule update --init --recursive
	pre-commit install --install-hooks
.PHONY: install

update:  ## Update deps and tools
	pre-commit autoupdate
.PHONY: update

run:  ## Run development server
	docker compose up --build
.PHONY: run


# =============================================================================
# CI
# =============================================================================
ci: lint test  ## Run CI tasks
.PHONY: ci

format:  ## Run autoformatters
	pre-commit run --all-files shfmt
.PHONY: format

lint:  ## Run all linters
	pre-commit run --all-files shellcheck
.PHONY: lint

test:  ## Run tests
	docker compose build
	./test/bats/bin/bats ./test
.PHONY: test
