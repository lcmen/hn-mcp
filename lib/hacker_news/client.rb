require 'net/http'
require 'json'
require 'uri'

module HackerNews
  class Client
    BASE_URL = 'https://hn.algolia.com/api/v1'

    def initialize
      @uri = URI(BASE_URL)
    end

    def get_top_stories(limit = 10)
      response = make_request('/search', {
        tags: 'front_page',
        hitsPerPage: limit
      })
      data = JSON.parse(response.body)
      Parser.parse_stories(data['hits'])
    end

    def get_new_stories(limit = 10)
      response = make_request('/search_by_date', {
        tags: 'story',
        hitsPerPage: limit
      })
      data = JSON.parse(response.body)
      Parser.parse_stories(data['hits'])
    end

    def get_ask_stories(limit = 10)
      response = make_request('/search', {
        tags: 'ask_hn',
        hitsPerPage: limit
      })
      data = JSON.parse(response.body)
      Parser.parse_stories(data['hits'])
    end

    def get_show_stories(limit = 10)
      response = make_request('/search', {
        tags: 'show_hn',
        hitsPerPage: limit
      })
      data = JSON.parse(response.body)
      Parser.parse_stories(data['hits'])
    end

    def get_job_stories(limit = 10)
      response = make_request('/search', {
        tags: 'job',
        hitsPerPage: limit
      })
      data = JSON.parse(response.body)
      Parser.parse_stories(data['hits'])
    end

    def get_comments(story_id, max_depth = 3)
      response = make_request('/search', {
        tags: 'comment',
        numericFilters: "story_id=#{story_id}",
        hitsPerPage: 1000
      })
      data = JSON.parse(response.body)
      
      # Build comment tree from flat list
      comment_data = build_comment_tree(data['hits'], max_depth)
      Parser.parse_comments(comment_data, max_depth, 0)
    end

    private

    def make_request(path, params = {})
      uri = URI("#{BASE_URL}#{path}")
      
      unless params.empty?
        uri.query = URI.encode_www_form(params)
      end
      
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Get.new(uri)
        response = http.request(request)
        
        unless response.is_a?(Net::HTTPSuccess)
          raise "HTTP Error: #{response.code} #{response.message}"
        end
        
        response
      end
    end

    def build_comment_tree(comments, max_depth)
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

    def limit_depth(comments, max_depth, current_depth)
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