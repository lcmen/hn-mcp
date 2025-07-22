# Hacker News MCP Server

This is a Hacker News MCP server built in Ruby using the [fast-mcp](https://github.com/yjacquin/fast-mcp) gem. The server runs as a Sinatra application and provides AI assistants with access to Hacker News data through two focused tools.

## Purpose

A learning project to understand MCP server architecture and demonstrate practical API integration.

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
bin/test
```

## Architecture

This is a simple Ruby web application with these key components:

- **`app.rb`**: Main Sinatra application that hosts the MCP server
- **`config.ru`**: Rack configuration file
- **Tool classes**: `GetStories` and `GetComments` that implement the two tools
- **HN API client**: Fetches data from Hacker News Firebase API
- **fast-mcp gem**: Handles all MCP protocol details (JSON-RPC, validation, routing)

The fast-mcp gem acts as Rack middleware, so you only need to focus on implementing the two tool classes and the HN API integration.

## Development Process

### Project Planning and Tracking

**IMPORTANT**: This project follows a structured development plan organized into 4 phases:

#### Phase 1: Basic Sinatra Application ✅
- [x] Create `Gemfile` with basic dependencies (Sinatra, mise configuration)
- [x] Set up project structure (lib/, test/, config/)
- [x] Create basic `app.rb` with simple Sinatra routes
- [x] Create `config.ru` for Rack configuration
- [x] Configure mise with Ruby 3.4.4
- [x] Set up minitest test structure
- [x] Create basic health check endpoint

#### Phase 2: Hacker News API Client ✅
- [x] Research HN Firebase API endpoints and implement client
- [x] Create `lib/hacker_news/client.rb` class with Algolia API
- [x] Implement story fetching (top, new, ask, show, job)
- [x] Implement comment fetching with tree building
- [x] Add error handling and HTTP client logic
- [x] Write comprehensive tests with WebMock

#### Phase 3: MCP Integration
- [ ] Add `fast-mcp` gem to Gemfile
- [ ] Create `lib/tools/get_stories.rb` inheriting from `FastMcp::Tool`
- [ ] Create `lib/tools/get_comments.rb` inheriting from `FastMcp::Tool`
- [ ] Define argument schemas for both tools
- [ ] Update `app.rb` to use fast-mcp middleware
- [ ] Test MCP protocol endpoints and tool discovery
- [ ] Create integration tests for complete MCP workflow

#### Phase 4: Production Deployment
- [ ] Create multi-stage Dockerfile with Ruby 3.4.4
- [ ] Add production-ready configuration
- [ ] Configure environment variables and logging
- [ ] Add health check endpoints
- [ ] Update documentation with deployment instructions

**When starting work:**
1. Check current phase progress above
2. Update checkboxes as you complete tasks
3. Focus on current phase tasks before moving to next phase
4. Test thoroughly at each step

### Working with this codebase

**Focus areas:**
- Implement the two tool classes: `GetStories` and `GetComments`
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

Uses Algolia's HN Search API at `https://hn.algolia.com/api/v1/`:

- **Stories**: `/search` with `tags` parameter (front_page, ask_hn, show_hn, job)
- **New stories**: `/search_by_date` with `tags=story`
- **Comments**: `/search` with `tags=comment` and `numericFilters=story_id=X`

The client handles tree building for nested comments and limits depth.

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
