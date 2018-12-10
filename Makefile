# ENV
PROJECT_NAME=silver-web-assembly

BIN_DIR=$(CURDIR)/bin


# Go parameters
GO_CMD=go
GO_BUILD=$(GO_CMD) build
GO_CLEAN=$(GO_CMD) clean
GO_TEST=$(GO_CMD) test
GO_DOC=$(GO_CMD) doc
GO_GET=$(GO_CMD) get
GO_FMT=$(GO_CMD)fmt
GO_IMPORTS=goimports
GO_MOD=$(GO_CMD) mod

# Tools
default: build

build:
	GOOS=js GOARCH=wasm $(GO_BUILD) -mod=vendor ${LDFLAGS} -o $(BIN_DIR)/$(PROJECT_NAME).wasm .
	@echo "$(CUR_TIME) [INFO ] Build $(PROJECT_NAME) completed"

clean:
	$(GO_CLEAN)
	rm $(BIN_DIR)/$(PROJECT_NAME).wasm
	@echo "$(CUR_TIME) [INFO ] Clean $(PROJECT_NAME) completed"

fmt:
	$(GO_FMT) -s -w .
	@echo "$(CUR_TIME) [INFO ] Go fmt completed"

ps:
	ps -ef | grep $(PROJECT_NAME)

stop:
	pgrep -f $(PROJECT_NAME) | xargs kill -9

vendor:
	$(GO_MOD) vendor

# Go docs
doc:
	$(GO_DOC) ./utils

# Static check
check: goimports gometalinter

goimports:
	goimports -w $(CURDIR)

gometalinter:
	gometalinter --vendor --fast --enable-gc --tests --aggregate --disable=gotype ./...

# .PHONY
.PHONY:	default dev build clean fmt ps dev-run stop vendor doc check goimports gometalinter
