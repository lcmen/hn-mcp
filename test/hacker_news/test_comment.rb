class TestComment < Minitest::Test
  def setup
    @comment = HackerNews::Comment.from_api_data({
      'objectID' => 456,
      'author' => 'commenter',
      'created_at_i' => 1609459200,
      'comment_text' => 'Parent comment',
      'parent_id' => 123,
      'replies' => [
        {
          'objectID' => 789,
          'author' => 'replier1',
          'comment_text' => 'Reply comment',
          'parent_id' => 456,
          'replies' => [
            { 'objectID' => 791, 'author' => 'nested_replier', 'comment_text' => 'Nested reply', 'replies' => [] }
          ]
        },
        { 'objectID' => 790, 'author' => 'replier2', 'comment_text' => 'Another reply', 'replies' => [] }
      ]
    })
  end

  def test_from_api_data
    assert_attributes({
      id: 456,
      by: 'commenter',
      time: 1609459200,
      text: 'Parent comment',
      parent: 123,
      reply_count: 2,
      total_reply_count: 3
    }, @comment)

    assert_attributes({
      id: 456,
      by: 'commenter',
      time: nil,
      text: nil,
      parent: nil,
      replies: [],
      reply_count: 0,
    }, HackerNews::Comment.from_api_data({'objectID' => 456, 'author' => 'commenter'}))
  end

  def test_nested_replies
    reply1, reply2 = @comment.replies
    assert_attributes({
      id: 789,
      by: 'replier1',
      text: 'Reply comment',
      parent: 456
    }, reply1)
    assert_attributes({
      id: 790,
      by: 'replier2',
      text: 'Another reply',
      parent: nil
    }, reply2)
  end

  def test_to_h
    assert_equal({
      id: 456,
      by: 'commenter',
      time: 1609459200,
      formatted_time: @comment.formatted_time,
      text: 'Parent comment',
      parent: 123,
      reply_count: 2,
      replies: [
        {
          id: 789,
          by: 'replier1',
          time: nil,
          formatted_time: nil,
          text: 'Reply comment',
          parent: 456,
          reply_count: 1,
          replies: [
            {
              id: 791,
              by: 'nested_replier',
              time: nil,
              formatted_time: nil,
              text: 'Nested reply',
              parent: nil,
              reply_count: 0,
              replies: []
            }
          ]
        },
        {
          id: 790,
          by: 'replier2',
          time: nil,
          formatted_time: nil,
          text: 'Another reply',
          parent: nil,
          reply_count: 0,
          replies: []
        }
      ]
    }, @comment.to_h)

    # Test without replies
    refute @comment.to_h(include_replies: false).key?(:replies)
  end

  def test_flatten
    assert_equal 4, @comment.flatten.length
    assert_equal [456, 789, 791, 790], @comment.flatten.map(&:id)
  end
end
