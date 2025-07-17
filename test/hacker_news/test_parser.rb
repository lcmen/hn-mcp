class TestParser < Minitest::Test
  def test_parse_stories
    story_data = [
      {
        'objectID' => 123,
        'title' => 'First Story',
        'url' => 'https://example.com/1',
        'points' => 42,
        '_tags' => ['story']
      },
      {
        'objectID' => 124,
        'title' => 'Second Story',
        'url' => 'https://example.com/2',
        'points' => 35,
        '_tags' => ['story']
      },
      nil  # Should be filtered out
    ]

    stories = HackerNews::Parser.parse_stories(story_data)

    assert_equal 2, stories.length
    assert_instance_of HackerNews::Story, stories.first
    assert_equal 123, stories.first.id
    assert_equal 'First Story', stories.first.title
    assert_equal 124, stories.last.id
    assert_equal 'Second Story', stories.last.title
    
    # Test empty array
    assert_equal [], HackerNews::Parser.parse_stories([])
  end

  def test_parse_comments
    comment_data = [
      {
        'objectID' => 456,
        'author' => 'user1',
        'comment_text' => 'First comment',
        'replies' => []
      },
      {
        'objectID' => 457,
        'author' => 'user2',
        'comment_text' => 'Second comment',
        'replies' => []
      },
      {
        'objectID' => 458,
        'author' => 'user3',
        'comment_text' => 'Deleted comment',
        'deleted' => true,
        'replies' => []
      },
      {
        'objectID' => 459,
        'author' => 'user4',
        'comment_text' => 'Dead comment',
        'dead' => true,
        'replies' => []
      }
    ]

    comments = HackerNews::Parser.parse_comments(comment_data)

    assert_equal 2, comments.length  # Deleted and dead comments filtered out
    assert_instance_of HackerNews::Comment, comments.first
    assert_equal 456, comments.first.id
    assert_equal 'user1', comments.first.by
    assert_equal 457, comments.last.id
    assert_equal 'user2', comments.last.by
    
    # Test empty array and nil
    assert_equal [], HackerNews::Parser.parse_comments([])
    assert_equal [], HackerNews::Parser.parse_comments(nil)
  end

  def test_parse_comments_with_nested_replies_and_depth
    comment_data = [
      {
        'objectID' => 456,
        'author' => 'user1',
        'comment_text' => 'Level 1',
        'replies' => [
          {
            'objectID' => 789,
            'author' => 'user2',
            'comment_text' => 'Level 2',
            'replies' => [
              {
                'objectID' => 790,
                'author' => 'user3',
                'comment_text' => 'Level 3',
                'replies' => []
              }
            ]
          }
        ]
      }
    ]

    # Test with default depth
    comments = HackerNews::Parser.parse_comments(comment_data)
    parent = comments.first
    assert_equal 456, parent.id
    assert_equal 1, parent.replies.length
    level2 = parent.replies.first
    assert_equal 789, level2.id
    assert_equal 1, level2.replies.length
    
    # Test with limited depth
    comments_limited = HackerNews::Parser.parse_comments(comment_data, max_depth = 2)
    parent_limited = comments_limited.first
    assert_equal 456, parent_limited.id
    assert_equal 1, parent_limited.replies.length
    level2_limited = parent_limited.replies.first
    assert_equal 789, level2_limited.id
    assert_equal 0, level2_limited.replies.length  # Cut off at depth 2
    
    # Test with current depth at limit
    comments_at_limit = HackerNews::Parser.parse_comments(comment_data, max_depth = 2, current_depth = 1)
    parent_at_limit = comments_at_limit.first
    assert_equal 456, parent_at_limit.id
    assert_equal 0, parent_at_limit.replies.length  # Cut off because current_depth + 1 >= max_depth
    
    # Test when max depth is reached
    assert_equal [], HackerNews::Parser.parse_comments(comment_data, max_depth = 1, current_depth = 1)
  end

end