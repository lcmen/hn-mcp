require_relative '../hacker_news'

class GetComments < FastMcp::Tool
  description 'Fetches comments from Hacker News for a specific story.'
  arguments do
    optional(:max_depth)
      .filled(:integer)
      .description('Maximum depth of comment threads to fetch (default is 3)')
    required(:story_id)
      .filled(:integer)
      .description('ID of the story to fetch comments for')
  end

  def call(story_id:, max_depth: 3)
    client = HackerNews::Client.new
    comments = client.get_comments(story_id, max_depth)

    {
      story_id: story_id,
      max_depth: max_depth,
      count: (comments || []).sum(&:total_reply_count),
      comments: comments.map(&:to_h)
    }
  rescue => e
    {
      error: "Failed to fetch comments: #{e.message}",
      story_id: story_id,
      max_depth: max_depth
    }
  end
end
