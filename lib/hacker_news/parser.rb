require_relative "story"
require_relative "comment"

module HackerNews
  class Parser
    def self.parse_stories(story_data)
      story_data.filter_map { |data| parse_story(data) }.compact
    end

    def self.parse_story(story_data)
      return nil if story_data.nil?

      Story.from_api_data(story_data)
    end

    def self.parse_comments(comments_array, max_depth = 3)
      comments_array = (comments_array || []).reject do |comment|
        comment["deleted"] || comment["dead"]
      end
      return [] if comments_array.nil? || comments_array.empty?

      # Build comment tree from flat list
      comment_tree = build_comment_tree(comments_array, max_depth)
      comment_tree.map { |comment| Comment.from_api_data(comment) }
    end

    def self.build_comment_tree(comments, max_depth)
      # Create a map of comments by their objectID
      comment_map = {}
      comments.each do |comment|
        comment_map[comment["objectID"]] = comment.merge("replies" => [])
      end

      # Build the tree structure
      root_comments = []

      comments.each do |comment|
        if comment["parent_id"] && comment_map[comment["parent_id"]]
          # This is a reply - add it to parent's replies
          parent = comment_map[comment["parent_id"]]
          parent["replies"] << comment_map[comment["objectID"]]
        else
          # This is a root comment
          root_comments << comment_map[comment["objectID"]]
        end
      end

      # Limit depth recursively
      limit_depth(root_comments, max_depth, 0)
    end

    def self.limit_depth(comments, max_depth, current_depth)
      return [] if current_depth >= max_depth

      comments.map do |comment|
        comment["replies"] = if current_depth < max_depth - 1
          limit_depth(comment["replies"], max_depth, current_depth + 1)
        else
          []
        end
        comment
      end
    end

    private_class_method :build_comment_tree, :limit_depth
  end
end
