.PHONY: deps
deps:
	pip install bashate

.PHONY: test
test: bashate

.PHONY: bashate
bashate:
	bashate $(shell find scripts -type f -iname *.sh)
