class GetStoriesTest < Minitest::Test
  def setup
    super
    @tool = GetStories.new
    @mock_client = Minitest::Mock.new
  end

  def teardown
    @mock_client.verify
  end

  def test_successful_top_stories_fetch
    @mock_client.expect(:get_top_stories, mock_stories(type: 'story'), [10])

    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_type: 'top')

      assert_equal({ story_type: 'top', limit: 10, count: 1 }, result.slice(:story_type, :limit, :count))
    end
  end

  def test_successful_new_stories_fetch
    @mock_client.expect(:get_new_stories, mock_stories(type: 'story'), [10])

    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_type: 'new')

      assert_equal({ story_type: 'new', limit: 10, count: 1 }, result.slice(:story_type, :limit, :count))
    end
  end

  def test_successful_best_stories_fetch
    @mock_client.expect(:get_top_stories, mock_stories(type: 'story'), [10])

    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_type: 'best')

      assert_equal({ story_type: 'best', limit: 10, count: 1 }, result.slice(:story_type, :limit, :count))
    end
  end

  def test_successful_ask_stories_fetch
    @mock_client.expect(:get_ask_stories, mock_stories(type: 'ask'), [10])

    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_type: 'ask')

      assert_equal({ story_type: 'ask', limit: 10, count: 1 }, result.slice(:story_type, :limit, :count))
    end
  end

  def test_successful_show_stories_fetch
    @mock_client.expect(:get_show_stories, mock_stories(type: 'show'), [10])

    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_type: 'show')

      assert_equal({ story_type: 'show', limit: 10, count: 1 }, result.slice(:story_type, :limit, :count))
    end
  end

  def test_successful_job_stories_fetch
    @mock_client.expect(:get_job_stories, mock_stories(type: 'job'), [10])

    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_type: 'job')

      assert_equal({ story_type: 'job', limit: 10, count: 1 }, result.slice(:story_type, :limit, :count))
    end
  end

  def test_custom_limit_parameter
    @mock_client.expect(:get_top_stories, mock_stories(type: 'story'), [5])

    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_type: 'top', limit: 5)

      assert_equal({ story_type: 'top', limit: 5, count: 1 }, result.slice(:story_type, :limit, :count))
    end
  end

  def test_default_limit_behavior
    @mock_client.expect(:get_top_stories, mock_stories(type: 'story'), [10])

    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_type: 'top')

      assert_equal 10, result[:limit]
    end
  end

  def test_empty_response_from_api
    @mock_client.expect(:get_top_stories, [], [10])

    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_type: 'top')

      assert_equal({ story_type: 'top', count: 0, stories: [] }, result.slice(:story_type, :count, :stories))
    end
  end

  def test_invalid_story_type_error_handling
    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_type: 'invalid')

      assert_includes result[:error], 'Invalid story type: invalid'
      assert_equal({ story_type: 'invalid', limit: 10 }, result.slice(:story_type, :limit))
    end
  end

  def test_client_error_handling
    @mock_client.expect(:get_top_stories, nil) do |limit|
      raise StandardError, "Network timeout"
    end

    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_type: 'top')

      assert_includes result[:error], 'Network timeout'
      assert_equal({ story_type: 'top', limit: 10 }, result.slice(:story_type, :limit))
    end
  end

  private

  def mock_stories(type: 'story')
    [
      HackerNews::Story.new(
        id: 123,
        title: 'Test Story',
        url: 'https://example.com',
        score: 100,
        by: 'author1',
        time: 1609459200,
        descendants: 50,
        text: nil,
        type: type
      )
    ]
  end
end
