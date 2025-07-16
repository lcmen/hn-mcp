# Hacker News MCP Server Development Plan

## Phase 1: Basic Sinatra Application
### 1.1 Project Setup
- [ ] Create `Gemfile` with basic dependencies (Sinatra, mise configuration)
- [ ] Set up project structure (lib/, test/, config/)
- [ ] Create basic `app.rb` with simple Sinatra routes
- [ ] Create `config.ru` for Rack configuration
- [ ] Test basic server startup with `ruby app.rb`

### 1.2 Development Environment
- [ ] Configure mise with Ruby 3.4.4
- [ ] Set up minitest test structure
- [ ] Create basic health check endpoint
- [ ] Add development dependencies (minitest, webmock for testing)

## Phase 2: Hacker News API Client
### 2.1 HN API Research & Client Setup
- [ ] Research HN Firebase API endpoints (`/topstories.json`, `/newstories.json`, `/item/{id}.json`)
- [ ] Create `lib/hacker_news_client.rb` class
- [ ] Add HTTP client gem (Net::HTTP or faraday)
- [ ] Implement basic API connectivity

### 2.2 API Client Implementation
- [ ] Implement `get_stories(type)` method for different story types
- [ ] Implement `get_item(id)` method for stories and comments
- [ ] Add basic error handling and timeouts
- [ ] Implement simple caching mechanism
- [ ] Write comprehensive tests with WebMock

### 2.3 API Client Testing
- [ ] Test all story types (top, new, best, ask, show, job)
- [ ] Test comment fetching with nested structure
- [ ] Test error conditions (API failures, invalid IDs)
- [ ] Test caching behavior

## Phase 3: MCP Integration
### 3.1 Add fast-mcp Gem
- [ ] Add `fast-mcp` gem to Gemfile
- [ ] Study fast-mcp documentation and examples
- [ ] Create basic MCP server configuration
- [ ] Test MCP server startup

### 3.2 Implement MCP Tools
- [ ] Create `lib/tools/get_stories_tool.rb` inheriting from `FastMcp::Tool`
- [ ] Create `lib/tools/get_comments_tool.rb` inheriting from `FastMcp::Tool`
- [ ] Define argument schemas for both tools
- [ ] Implement `call` methods connecting to HN API client
- [ ] Handle errors properly with MCP error responses

### 3.3 MCP Server Integration
- [ ] Update `app.rb` to use fast-mcp middleware
- [ ] Register both tools with MCP server
- [ ] Configure MCP server settings (name, version, etc.)
- [ ] Test MCP protocol endpoints (`/mcp/messages`, `/mcp/sse`)

### 3.4 End-to-End Testing
- [ ] Test MCP tool discovery (`tools/list`)
- [ ] Test `get_stories` tool with different parameters
- [ ] Test `get_comments` tool with various story IDs
- [ ] Test error scenarios (invalid parameters, API failures)
- [ ] Create integration tests for complete MCP workflow

## Phase 4: Production Deployment
### 4.1 Dockerfile Creation
- [ ] Create multi-stage Dockerfile with Ruby 3.4.4
- [ ] Set up production environment configuration
- [ ] Configure proper logging and error handling
- [ ] Optimize image size and security

### 4.2 Production Configuration
- [ ] Add production-ready configuration
- [ ] Configure environment variables
- [ ] Set up proper logging
- [ ] Add health check endpoints
- [ ] Test Docker build and run locally

### 4.3 Documentation & Finalization
- [ ] Update README.md with deployment instructions
- [ ] Update CLAUDE.md with final project structure
- [ ] Add example usage and API documentation
- [ ] Create simple deployment guide

## Testing Strategy Throughout
- Write tests for each component as it's built
- Use minitest for all testing
- Mock external API calls with WebMock
- Test error conditions and edge cases
- Integration tests for complete workflows

## Key Milestones
1. ✅ Basic Sinatra app running
2. ✅ HN API client working with tests
3. ✅ MCP tools integrated and functional
4. ✅ Complete MCP server working end-to-end
5. ✅ Dockerized and deployment-ready

## Progress Tracking
- [ ] Phase 1 Complete
- [ ] Phase 2 Complete
- [ ] Phase 3 Complete
- [ ] Phase 4 Complete

This plan follows the iterative approach, building complexity gradually while maintaining working functionality at each stage.