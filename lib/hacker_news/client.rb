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
      response = make_request('/search', { tags: 'front_page', hitsPerPage: limit })
      parse_stories(response)
    end

    def get_new_stories(limit = 10)
      response = make_request('/search_by_date', { tags: 'story', hitsPerPage: limit })
      parse_stories(response)
    end

    def get_ask_stories(limit = 10)
      response = make_request('/search', { tags: 'ask_hn', hitsPerPage: limit })
      parse_stories(response)
    end

    def get_show_stories(limit = 10)
      response = make_request('/search', { tags: 'show_hn', hitsPerPage: limit })
      parse_stories(response)
    end

    def get_job_stories(limit = 10)
      response = make_request('/search', { tags: 'job', hitsPerPage: limit })
      parse_stories(response)
    end

    def get_comments(story_id, max_depth = 3)
      response = make_request('/search', { tags: 'comment', numericFilters: "story_id=#{story_id}", hitsPerPage: 1000 })
      parse_comments(response, max_depth)
    end

    private

    def make_request(path, params = {})
      uri = URI("#{BASE_URL}#{path}")
      uri.query = URI.encode_www_form(params) unless params.empty?

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Get.new(uri)
        response = http.request(request)

        raise("HTTP Error: #{response.code} #{response.message}") unless response.is_a?(Net::HTTPSuccess)

        response
      end
    end

    def parse_comments(response, max_depth)
      data = JSON.parse(response.body)
      Parser.parse_comments(data['hits'], max_depth)
    end

    def parse_stories(response)
      data = JSON.parse(response.body)
      Parser.parse_stories(data['hits'])
    end
  end
end
