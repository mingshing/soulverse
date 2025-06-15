# iOS Project Makefile
# Automatically detects project and scheme names

# Variables
PROJECT_FILE := $(shell find . -name "*.xcodeproj" -type d | head -1)
WORKSPACE_FILE := $(shell find . -name "*.xcworkspace" -type d | head -1)
PROJECT_NAME := $(shell basename "$(PROJECT_FILE)" .xcodeproj)
SCHEME_NAME ?= $(PROJECT_NAME)

# Default target
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make rebuild-lsp    - Rebuild SourceKit-LSP build server configuration"
	@echo "  make clean-lsp      - Clean and rebuild LSP configuration"
	@echo "  make show-config    - Show current project configuration"
	@echo "  make install-deps   - Install required dependencies"

# Rebuild SourceKit-LSP configuration
.PHONY: rebuild-lsp
rebuild-lsp:
	@if [ -n "$(WORKSPACE_FILE)" ]; then \
		echo "Using workspace: $(WORKSPACE_FILE)"; \
		xcode-build-server config -workspace "$(WORKSPACE_FILE)" -scheme "$(SCHEME_NAME)"; \
	elif [ -n "$(PROJECT_FILE)" ]; then \
		echo "Using project: $(PROJECT_FILE)"; \
		xcode-build-server config -project "$(PROJECT_FILE)" -scheme "$(SCHEME_NAME)"; \
	else \
		echo "Error: No .xcodeproj or .xcworkspace found in current directory"; \
		exit 1; \
	fi
	@echo "✅ SourceKit-LSP configuration rebuilt successfully"

# Clean and rebuild LSP configuration
.PHONY: clean-lsp
clean-lsp:
	@echo "Cleaning existing build server configuration..."
	@rm -f buildServer.json
	@make rebuild-lsp

# Show current project configuration
.PHONY: show-config
show-config:
	@echo "Project Configuration:"
	@echo "  Project file: $(PROJECT_FILE)"
	@echo "  Workspace file: $(WORKSPACE_FILE)"
	@echo "  Project name: $(PROJECT_NAME)"
	@echo "  Scheme name: $(SCHEME_NAME)"
	@if [ -f buildServer.json ]; then \
		echo "  Build server config: ✅ exists"; \
		echo "  Config content:"; \
		cat buildServer.json | jq . 2>/dev/null || cat buildServer.json; \
	else \
		echo "  Build server config: ❌ missing"; \
	fi

# Install required dependencies
.PHONY: install-deps
install-deps:
	@echo "Installing xcode-build-server..."
	@if command -v brew >/dev/null 2>&1; then \
		brew install xcode-build-server; \
		echo "✅ xcode-build-server installed"; \
	else \
		echo "❌ Homebrew not found. Please install Homebrew first:"; \
		echo "  /bin/bash -c \"\$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""; \
		exit 1; \
	fi

# Custom scheme (override default)
.PHONY: rebuild-lsp-custom
rebuild-lsp-custom:
	@read -p "Enter scheme name: " scheme; \
	make rebuild-lsp SCHEME_NAME=$$scheme

# Quick commands for common schemes
.PHONY: rebuild-debug rebuild-release
rebuild-debug:
	@make rebuild-lsp SCHEME_NAME="$(PROJECT_NAME) Debug"

rebuild-release:
	@make rebuild-lsp SCHEME_NAME="$(PROJECT_NAME) Release"
