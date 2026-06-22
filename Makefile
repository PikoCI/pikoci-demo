.PHONY: build lint test

build: ## Build the binary
	go build -o pikoci-demo .

lint: ## Run go vet
	go vet ./...

test: ## Run tests
	go test ./...
