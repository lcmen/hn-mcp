class TestComment < Minitest::Test
  def test_from_api_data_with_all_fields
    api_data = {
      'objectID' => 456,
      'author' => 'commenter',
      'created_at_i' => 1609459200,
      'comment_text' => 'This is a comment',
      'parent_id' => 123,
      'replies' => []
    }

    comment = HackerNews::Comment.from_api_data(api_data)

    assert_equal 456, comment.id
    assert_equal 'commenter', comment.by
    assert_equal 1609459200, comment.time
    assert_equal 'This is a comment', comment.text
    assert_equal 123, comment.parent
    assert_equal [], comment.replies
    
    # Test time formatting
    assert_match /\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/, comment.formatted_time
    
    # Test count methods
    assert_equal 0, comment.reply_count
    assert_equal 0, comment.total_reply_count
  end

  def test_from_api_data_with_missing_fields
    api_data = {
      'objectID' => 456,
      'author' => 'commenter'
    }

    comment = HackerNews::Comment.from_api_data(api_data)

    assert_equal 456, comment.id
    assert_equal 'commenter', comment.by
    assert_nil comment.time
    assert_nil comment.text
    assert_nil comment.parent
    assert_equal [], comment.replies
    
    # Test time formatting with nil
    assert_nil comment.formatted_time
    
    # Test count methods with missing data
    assert_equal 0, comment.reply_count
  end

  def test_nested_replies
    api_data = {
      'objectID' => 456,
      'author' => 'commenter',
      'comment_text' => 'Parent comment',
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
    }

    comment = HackerNews::Comment.from_api_data(api_data)

    assert_equal 2, comment.replies.length
    reply = comment.replies.first
    assert_equal 789, reply.id
    assert_equal 'replier1', reply.by
    assert_equal 'Reply comment', reply.text
    assert_equal 456, reply.parent
    
    # Test reply counting
    assert_equal 2, comment.reply_count
    assert_equal 3, comment.total_reply_count
  end

  def test_to_h_serialization
    api_data = {
      'objectID' => 456,
      'author' => 'commenter',
      'created_at_i' => 1609459200,
      'comment_text' => 'Comment text',
      'parent_id' => 123,
      'replies' => [
        { 'objectID' => 789, 'author' => 'replier', 'comment_text' => 'Reply', 'replies' => [] }
      ]
    }

    comment = HackerNews::Comment.from_api_data(api_data)
    
    # Test with replies included
    hash = comment.to_h
    assert_equal 456, hash[:id]
    assert_equal 'commenter', hash[:by]
    assert_equal 1609459200, hash[:time]
    assert_match /\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/, hash[:formatted_time]
    assert_equal 'Comment text', hash[:text]
    assert_equal 123, hash[:parent]
    assert_equal 1, hash[:reply_count]
    assert_equal 1, hash[:replies].length
    assert_equal 789, hash[:replies].first[:id]
    
    # Test without replies
    hash_no_replies = comment.to_h(include_replies: false)
    refute hash_no_replies.key?(:replies)
  end

  def test_flatten
    api_data = {
      'objectID' => 456,
      'author' => 'commenter',
      'replies' => [
        {
          'objectID' => 789,
          'author' => 'replier1',
          'replies' => [
            { 'objectID' => 791, 'author' => 'nested_replier', 'replies' => [] }
          ]
        },
        { 'objectID' => 790, 'author' => 'replier2', 'replies' => [] }
      ]
    }

    comment = HackerNews::Comment.from_api_data(api_data)
    flattened = comment.flatten

    assert_equal 4, flattened.length
    assert_equal [456, 789, 791, 790], flattened.map(&:id)
  end

end