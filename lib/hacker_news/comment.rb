module HackerNews
  Comment = Data.define(:id, :by, :time, :text, :parent, :replies) do
    def self.from_api_data(data)
      new(
        id: data['objectID'],
        by: data['author'],
        time: data['created_at_i'],
        text: data['comment_text'],
        parent: data['parent_id'],
        replies: (data['replies'] || []).map { |reply_data| Comment.from_api_data(reply_data) }
      )
    end

    def formatted_time
      return nil unless time
      Time.at(time).strftime('%Y-%m-%d %H:%M:%S')
    end


    def reply_count
      replies.length
    end

    def total_reply_count
      replies.sum { |reply| 1 + reply.total_reply_count }
    end

    def to_h(include_replies: true)
      hash = {
        id: id,
        by: by,
        time: time,
        formatted_time: formatted_time,
        text: text,
        parent: parent,
        reply_count: reply_count
      }

      if include_replies
        hash[:replies] = replies.map { |reply| reply.to_h(include_replies: true) }
      end

      hash
    end

    def flatten
      result = [self]
      replies.each { |reply| result.concat(reply.flatten) }
      result
    end
  end
end