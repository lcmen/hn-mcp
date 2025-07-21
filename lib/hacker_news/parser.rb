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

    def self.parse_comments(comments_array, max_depth = 3)
      return [] if comments_array.nil? || comments_array.empty?

      # If comments are already nested (have 'replies' key), parse directly
      if comments_array.first&.key?('replies')
        return parse_nested_comments(comments_array, max_depth, 0)
      end

      # Build comment tree from flat list
      comment_tree = build_comment_tree(comments_array, max_depth)
      parse_nested_comments(comment_tree, max_depth, 0)
    end

    def self.parse_nested_comments(comment_data_array, max_depth = 3, current_depth = 0)
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
        replies = parse_nested_comments(comment_data['replies'], max_depth, current_depth + 1)
      end

      # Create new comment data with parsed replies
      parsed_comment_data = comment_data.merge('replies' => replies)
      Comment.from_api_data(parsed_comment_data)
    end

    private

    def self.build_comment_tree(comments, max_depth)
      # Create a map of comments by their objectID
      comment_map = {}
      comments.each do |comment|
        comment_map[comment['objectID']] = comment.merge('replies' => [])
      end

      # Build the tree structure
      root_comments = []

      comments.each do |comment|
        if comment['parent_id'] && comment_map[comment['parent_id']]
          # This is a reply - add it to parent's replies
          parent = comment_map[comment['parent_id']]
          parent['replies'] << comment_map[comment['objectID']]
        else
          # This is a root comment
          root_comments << comment_map[comment['objectID']]
        end
      end

      # Limit depth recursively
      limit_depth(root_comments, max_depth, 0)
    end

    def self.limit_depth(comments, max_depth, current_depth)
      return [] if current_depth >= max_depth

      comments.map do |comment|
        if current_depth < max_depth - 1
          comment['replies'] = limit_depth(comment['replies'], max_depth, current_depth + 1)
        else
          comment['replies'] = []
        end
        comment
      end
    end
  end
end