module HackerNews
  Story = Data.define(:id, :title, :url, :score, :by, :time, :descendants, :text, :type) do
    def self.from_api_data(data)
      new(
        id: data['story_id'] || data['objectID'],
        title: data['title'],
        url: data['url'],
        score: data['points'],
        by: data['author'],
        time: data['created_at_i'],
        descendants: data['num_comments'],
        text: data['story_text'],
        type: extract_type(data['_tags'])
      )
    end

    def comment_count
      descendants || 0
    end

    private

    def self.extract_type(tags)
      return nil unless tags

      if tags.include?('ask_hn')
        'ask'
      elsif tags.include?('show_hn')
        'show'
      elsif tags.include?('job')
        'job'
      else
        'story'
      end
    end
  end
end
