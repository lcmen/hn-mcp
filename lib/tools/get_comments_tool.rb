require_relative '../hacker_news'

class GetCommentsTool < FastMcp::Tool
  def initialize
    super(
      name: 'get_comments',
      description: 'Fetch comments for a specific Hacker News story',
      arguments: {
        story_id: {
          type: 'integer',
          description: 'The ID of the story to fetch comments for',
          required: true
        },
        max_depth: {
          type: 'integer',
          description: 'Maximum depth of comment threads to fetch (default: 3)',
          minimum: 1,
          maximum: 10,
          required: false
        }
      }
    )
  end

  def call(story_id:, max_depth: 3)
    client = HackerNews::Client.new

    comments = client.get_comments(story_id, max_depth)

    {
      story_id: story_id,
      max_depth: max_depth,
      count: count_comments(comments),
      comments: comments.map(&:to_h)
    }
  rescue => e
    {
      error: "Failed to fetch comments: #{e.message}",
      story_id: story_id,
      max_depth: max_depth
    }
  end

  private

  def count_comments(comments)
    return 0 if comments.nil? || comments.empty?

    comments.sum do |comment|
      1 + count_comments(comment.replies)
    end
  end
end
