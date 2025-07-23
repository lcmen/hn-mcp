require_relative "../hacker_news"

class GetStories < FastMcp::Tool
  description "Fetches stories from Hacker News based on the specified type and limit."
  arguments do
    optional(:limit)
      .filled(:integer)
      .description("Number of stories to fetch (default is 10)")
    required(:story_type)
      .filled(:string)
      .description("Type of stories to fetch (top, new, best, ask, show, job)")
  end

  def call(story_type:, limit: 10)
    stories = get_stories(story_type, limit)

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

  private

  def get_stories(story_type, limit)
    client = HackerNews::Client.new
    case story_type
    when "top" then client.get_top_stories(limit)
    when "new" then client.get_new_stories(limit)
    when "best" then client.get_top_stories(limit)
    when "ask" then client.get_ask_stories(limit)
    when "show" then client.get_show_stories(limit)
    when "job" then client.get_job_stories(limit)
    else raise ArgumentError, "Invalid story type: #{story_type}"
    end
  end
end
