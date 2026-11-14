NVIM ?= nvim

.PHONY: docs check-docs self-test fmt fmt-check lint check

docs:
	$(NVIM) --clean -l scripts/gen_docs.lua --write

check-docs:
	$(NVIM) --clean -l scripts/gen_docs.lua --check

self-test:
	$(NVIM) --clean -l scripts/gen_docs.lua --self-test

fmt:
	stylua lua scripts

fmt-check:
	stylua --check lua scripts

lint:
	luacheck lua scripts

check: lint check-docs
