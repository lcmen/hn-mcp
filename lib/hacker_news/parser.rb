require_relative 'story'
require_relative 'comment'

module HackerNews
  class Parser
    def self.parse_stories(story_data_array)
      story_data_array.map { |story_data| Story.from_api_data(story_data) }.compact
    end

    def self.parse_story(story_data)
      return nil if story_data.nil?
      Story.from_api_data(story_data)
    end

    def self.parse_comments(comment_data_array, max_depth = 3, current_depth = 0)
      return [] if current_depth >= max_depth || comment_data_array.nil?

      comment_data_array.map do |comment_data|
        parse_comment(comment_data, max_depth, current_depth)
      end.compact
    end

    def self.parse_comment(comment_data, max_depth = 3, current_depth = 0)
      return nil if comment_data.nil? || comment_data['deleted'] || comment_data['dead']

      # Parse nested replies if they exist and we haven't reached max depth
      replies = []
      if comment_data['replies'] && current_depth < max_depth - 1
        replies = parse_comments(comment_data['replies'], max_depth, current_depth + 1)
      end

      # Create new comment data with parsed replies
      parsed_comment_data = comment_data.merge('replies' => replies)
      Comment.from_api_data(parsed_comment_data)
    end
  end
end