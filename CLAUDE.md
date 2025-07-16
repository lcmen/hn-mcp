# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Hacker News MCP server built in Ruby using the [fast-mcp](https://github.com/yjacquin/fast-mcp) gem. The server runs as a Sinatra application and provides AI assistants with access to Hacker News data through two focused tools.

**Purpose**: A learning project to understand MCP server architecture and demonstrate practical API integration.

## Core Functionality

The server provides **exactly two tools**:

### `get_stories`
- Fetches stories from different HN sections (top, new, best, ask, show, job)
- Parameters: `story_type` (required), `limit` (optional, default 10)

### `get_comments`  
- Fetches comments for a specific HN story
- Parameters: `story_id` (required), `max_depth` (optional, default 3)

## Development Environment

- **Ruby**: 3.4.4 (managed via mise)
- **Framework**: Sinatra with fast-mcp gem
- **Testing**: minitest
- **Dependencies**: Managed via Bundler

## Common Commands

### Setup
```bash
# Install Ruby version
mise install

# Activate environment  
mise use

# Install dependencies
bundle install
```

### Development
```bash
# Run the server
ruby app.rb

# Run with auto-reload
ruby app.rb -e development

# Run tests
bundle exec ruby -Itest test/test_*.rb
```

## Architecture

This is a simple Ruby web application with these key components:

- **`app.rb`**: Main Sinatra application that hosts the MCP server
- **`config.ru`**: Rack configuration file
- **Tool classes**: `GetStoriesTools` and `GetCommentsTool` that implement the two tools
- **HN API client**: Fetches data from Hacker News Firebase API
- **fast-mcp gem**: Handles all MCP protocol details (JSON-RPC, validation, routing)

The fast-mcp gem acts as Rack middleware, so you only need to focus on implementing the two tool classes and the HN API integration.

## Development Guidelines

### Working with this codebase

**Focus areas:**
- Implement the two tool classes: `GetStoriesTools` and `GetCommentsTool`
- Integrate with Hacker News Firebase API (`https://hacker-news.firebaseio.com/v0/`)
- Write tests using minitest
- Keep code simple and educational

**What fast-mcp handles for you:**
- All MCP protocol details (JSON-RPC, validation, routing)
- Parameter validation using schemas
- Error handling and response formatting
- Tool discovery and execution

### Tool Implementation

When implementing tools, follow this pattern:
- Inherit from `FastMcp::Tool`
- Define a clear `description`
- Specify `arguments` schema for validation
- Implement the `call` method with the core logic
- Handle API errors gracefully

### Hacker News API Integration

- Use the official Firebase API: `https://hacker-news.firebaseio.com/v0/`
- Key endpoints: `/topstories.json`, `/newstories.json`, `/item/{id}.json`
- Implement basic caching to reduce API calls
- Handle API failures with meaningful error messages

### Testing

- Use minitest for all tests
- Test both tool classes thoroughly
- Mock HN API calls in tests
- Focus on edge cases and error conditions

### Code Organization

- Keep tool classes focused and single-purpose
- Use clear, descriptive method names
- Follow Ruby conventions for naming and structure
- Prioritize readability and learning value