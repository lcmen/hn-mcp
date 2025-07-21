require_relative '../hacker_news'

class GetStoriesTool < FastMcp::Tool
  def initialize
    super(
      name: 'get_stories',
      description: 'Fetch stories from Hacker News by type (top, new, best, ask, show, job)',
      arguments: {
        story_type: {
          type: 'string',
          description: 'Type of stories to fetch',
          enum: ['top', 'new', 'best', 'ask', 'show', 'job'],
          required: true
        },
        limit: {
          type: 'integer',
          description: 'Number of stories to fetch (default: 10, max: 50)',
          minimum: 1,
          maximum: 50,
          required: false
        }
      }
    )
  end

  def call(story_type:, limit: 10)
    client = HackerNews::Client.new

    stories = case story_type
    when 'top'
      client.get_top_stories(limit)
    when 'new'
      client.get_new_stories(limit)
    when 'best'
      client.get_top_stories(limit)
    when 'ask'
      client.get_ask_stories(limit)
    when 'show'
      client.get_show_stories(limit)
    when 'job'
      client.get_job_stories(limit)
    else
      raise ArgumentError, "Invalid story type: #{story_type}"
    end

    {
      story_type: story_type,
      limit: limit,
      count: stories.length,
      stories: stories.map(&:to_h)
    }
  rescue => e
    {
      error: "Failed to fetch stories: #{e.message}",
      story_type: story_type,
      limit: limit
    }
  end
end
