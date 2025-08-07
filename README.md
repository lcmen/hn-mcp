# Hacker News MCP Server

A simple Ruby server that allows AI assistants like Claude to access Hacker News data. Built as a learning project to understand how MCP (Model Context Protocol) works.

## What does this do?

This server provides AI assistants with two useful tools:

- **Get Stories**: Fetches the latest stories from Hacker News (top, new, best, etc.)
- **Get Comments**: Reads comments from any Hacker News story

The server acts as a bridge between AI assistants and the Hacker News API, making it easy to integrate HN data into AI conversations.

## Available Tools

### `get_stories`

Fetches stories from different Hacker News sections.

**Arguments:**

- `story_type` (required, string): Type of stories to fetch
  - Valid values: `"top"`, `"new"`, `"best"`, `"ask"`, `"show"`, `"job"`
- `limit` (optional, integer): Number of stories to return
  - Range: 1-100
  - Default: 10

### `get_comments`

Fetches comments for a specific Hacker News story.

**Arguments:**

- `story_id` (required, integer): The Hacker News story ID
- `max_depth` (optional, integer): Maximum depth of comment threads to fetch
  - Default: 3

## Quick Start

### Requirements

- Ruby 3.4.4 (we use `mise` to manage Ruby versions)

### Setup

```bash
# Install Ruby version
mise install

# Activate environment
mise use

# Install dependencies
bundle install
```

### Run the Server

```bash
# Start the server
RACK_ENV={development|production|test} AUTH_TOKEN={your_auth_token} bundle exec rackup

# For development with auto-reload
bin/dev
```

### Testing

```bash
# Run tests
bin/test

# Run linter
bundle exec rake lint

# Run linter with autofix
bundle exec rake lint_fix

# Run both linter and tests
bundle exec rake
```

## How it works

This server uses the [fast-mcp](https://github.com/yjacquin/fast-mcp) Ruby gem as Rack middleware in a Sinatra application. When an AI assistant connects:

1. The fast-mcp server handles the MCP protocol (JSON-RPC 2.0 over HTTP)
2. AI assistants discover available tools via the `tools/list` method
3. When a tool is called, fast-mcp validates the arguments and routes them to the appropriate tool class
4. The tool fetches data from the Hacker News Firebase API
5. Results are returned in MCP-compliant format to the AI assistant

## Authentication

The MCP server is protected by an `Authorization` header that expects a value in the form of `Bearer $AUTH_TOKEN`, where `$AUTH_TOKEN` is the token you set via the `AUTH_TOKEN` environment variable when starting the server.

## About this project

This is a learning project to understand MCP (Model Context Protocol) server architecture. It's built using the [fast-mcp](https://github.com/yjacquin/fast-mcp) Ruby gem.

## License

This project is for educational purposes and demonstration of MCP server architecture.
