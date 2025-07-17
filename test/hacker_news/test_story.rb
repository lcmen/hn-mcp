class TestStory < Minitest::Test
  def test_from_api_data_with_all_fields
    api_data = {
      'objectID' => 123,
      'title' => 'Test Story',
      'url' => 'https://example.com',
      'points' => 42,
      'author' => 'testuser',
      'created_at_i' => 1609459200,
      'num_comments' => 10,
      'story_text' => 'Story text content',
      '_tags' => ['story', 'author_testuser']
    }

    story = HackerNews::Story.from_api_data(api_data)

    assert_equal 123, story.id
    assert_equal 'Test Story', story.title
    assert_equal 'https://example.com', story.url
    assert_equal 42, story.score
    assert_equal 'testuser', story.by
    assert_equal 1609459200, story.time
    assert_equal 10, story.descendants
    assert_equal 'Story text content', story.text
    assert_equal 'story', story.type
    
    # Test time formatting
    assert_match /\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/, story.formatted_time
    
    # Test count method
    assert_equal 10, story.comment_count
  end

  def test_from_api_data_with_missing_fields
    api_data = {
      'objectID' => 123,
      'title' => 'Test Story',
      'author' => 'testuser'
    }

    story = HackerNews::Story.from_api_data(api_data)

    assert_equal 123, story.id
    assert_equal 'Test Story', story.title
    assert_equal 'testuser', story.by
    assert_nil story.url
    assert_nil story.score
    assert_nil story.time
    assert_nil story.descendants
    assert_nil story.text
    assert_nil story.type
    
    # Test time formatting with nil
    assert_nil story.formatted_time
    
    # Test count method with missing data
    assert_equal 0, story.comment_count
  end
end