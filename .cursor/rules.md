# Cursor Rules for hn-mcp Project

## Project Structure & Conventions

- Organize new code into the appropriate directories: `lib/` for core logic, `test/` for tests, `config/` for configuration.
- Name files and classes following Ruby conventions (snake_case for files, CamelCase for classes).

## Tool Implementation

- All MCP tools must inherit from `FastMcp::Tool`.
- Each tool class must define:
  - A clear `description`.
  - An `arguments` schema for parameter validation.
  - A `call` method containing the tool’s logic.
- Handle API errors gracefully and return informative error messages.

## API Integration

- Use the Algolia HN Search API for stories and comments.
- For stories, use `/search` with appropriate `tags`.
- For new stories, use `/search_by_date` with `tags=story`.
- For comments, use `/search` with `tags=comment` and `numericFilters=story_id=X`.
- Limit comment tree depth as specified by the `max_depth` parameter.

## Testing

- Use minitest for all tests.
- Mock external API calls in tests.
- Cover edge cases and error conditions.
- Place tests for each class in a corresponding file under `test/`.

## Development Workflow

- Follow the phased development plan; do not skip ahead.
- Update checkboxes in documentation as tasks are completed.
- Test thoroughly before moving to the next phase.

## Code Style

- Write idiomatic Ruby code.
- Prioritize readability and educational value.
- Use clear, descriptive method and variable names.
- Keep classes and methods single-purpose.

## Dependencies

- Manage Ruby dependencies with Bundler (`Gemfile`).
- Use mise for Ruby version management.

## Documentation

- Update documentation when adding new features or making significant changes.
- Document public methods and classes with clear comments.
