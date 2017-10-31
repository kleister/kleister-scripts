.PHONY: test
test: bashate

.PHONY: bashate
bashate: bashate-deps
	bashate $(shell find scripts -type f -iname *.sh)

.PHONY: bashate-deps
bashate-deps:
	pip install bashate
