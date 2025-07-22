require_relative '../helper'

class TestClient < Minitest::Test
  def setup
    super
    @client = HackerNews::Client.new
  end

  def test_get_top_stories
    stub_request(:get, "https://hn.algolia.com/api/v1/search?hitsPerPage=10&tags=front_page")
      .to_return(status: 200, body: stories_response, headers: {'Content-Type' => 'application/json'})

    stories = @client.get_top_stories(10)

    assert_equal 2, stories.length
    assert_equal 123, stories.first.id
    assert_equal 'Test Story 1', stories.first.title
  end

  def test_get_new_stories
    stub_request(:get, "https://hn.algolia.com/api/v1/search_by_date?hitsPerPage=5&tags=story")
      .to_return(status: 200, body: stories_response, headers: {'Content-Type' => 'application/json'})

    stories = @client.get_new_stories(5)

    assert_equal 2, stories.length
    assert_equal 123, stories.first.id
  end

  def test_get_ask_stories
    stub_request(:get, "https://hn.algolia.com/api/v1/search?hitsPerPage=10&tags=ask_hn")
      .to_return(status: 200, body: stories_response, headers: {'Content-Type' => 'application/json'})

    stories = @client.get_ask_stories

    assert_equal 2, stories.length
    assert_equal 123, stories.first.id
  end

  def test_get_show_stories
    stub_request(:get, "https://hn.algolia.com/api/v1/search?hitsPerPage=10&tags=show_hn")
      .to_return(status: 200, body: stories_response, headers: {'Content-Type' => 'application/json'})

    stories = @client.get_show_stories

    assert_equal 2, stories.length
    assert_equal 123, stories.first.id
  end

  def test_get_job_stories
    stub_request(:get, "https://hn.algolia.com/api/v1/search?hitsPerPage=10&tags=job")
      .to_return(status: 200, body: stories_response, headers: {'Content-Type' => 'application/json'})

    stories = @client.get_job_stories

    assert_equal 2, stories.length
    assert_equal 123, stories.first.id
  end

  def test_get_comments
    stub_request(:get, "https://hn.algolia.com/api/v1/search?hitsPerPage=1000&numericFilters=story_id%3D123&tags=comment")
      .to_return(status: 200, body: comments_response, headers: {'Content-Type' => 'application/json'})

    comments = @client.get_comments(123, 2)

    assert_equal 1, comments.length
    assert_equal 456, comments.first.id
    assert_equal 'commenter1', comments.first.by
    assert_equal 1, comments.first.replies.length
    assert_equal 789, comments.first.replies.first.id
  end

  def test_get_comments_with_max_depth
    stub_request(:get, "https://hn.algolia.com/api/v1/search?hitsPerPage=1000&numericFilters=story_id%3D123&tags=comment")
      .to_return(status: 200, body: comments_nested_response, headers: {'Content-Type' => 'application/json'})

    comments = @client.get_comments(123, 1)

    # Should only have 1 level of depth
    assert_equal 1, comments.length
    assert_equal 0, comments.first.replies.length
  end

  def test_http_error_handling
    stub_request(:get, "https://hn.algolia.com/api/v1/search?hitsPerPage=10&tags=front_page")
      .to_return(status: 500, body: "Internal Server Error")

    error = assert_raises(RuntimeError) do
      @client.get_top_stories
    end

    assert_match(/HTTP Error: 500/, error.message)
  end

  def test_json_parsing_error
    stub_request(:get, "https://hn.algolia.com/api/v1/search?hitsPerPage=10&tags=front_page")
      .to_return(status: 200, body: "invalid json", headers: {'Content-Type' => 'application/json'})

    error = assert_raises(JSON::ParserError) do
      @client.get_top_stories
    end

    assert_match(/unexpected/, error.message)
  end

  private

  def stories_response
    {
      'hits' => [
        {
          'objectID' => 123,
          'title' => 'Test Story 1',
          'author' => 'author1',
          'created_at_i' => 1609459200,
          'points' => 100,
          'num_comments' => 50,
          'url' => 'https://example.com/story1'
        },
        {
          'objectID' => 124,
          'title' => 'Test Story 2',
          'author' => 'author2',
          'created_at_i' => 1609459300,
          'points' => 75,
          'num_comments' => 25,
          'url' => 'https://example.com/story2'
        }
      ]
    }.to_json
  end

  def comments_response
    {
      'hits' => [
        {
          'objectID' => 456,
          'author' => 'commenter1',
          'created_at_i' => 1609459200,
          'comment_text' => 'Root comment',
          'story_id' => 123
        },
        {
          'objectID' => 789,
          'author' => 'commenter2',
          'created_at_i' => 1609459300,
          'comment_text' => 'Reply comment',
          'parent_id' => 456,
          'story_id' => 123
        }
      ]
    }.to_json
  end

  def comments_nested_response
    {
      'hits' => [
        {
          'objectID' => 456,
          'author' => 'commenter1',
          'created_at_i' => 1609459200,
          'comment_text' => 'Root comment',
          'story_id' => 123
        },
        {
          'objectID' => 789,
          'author' => 'commenter2',
          'created_at_i' => 1609459300,
          'comment_text' => 'Reply comment',
          'parent_id' => 456,
          'story_id' => 123
        },
        {
          'objectID' => 790,
          'author' => 'commenter3',
          'created_at_i' => 1609459400,
          'comment_text' => 'Deep reply',
          'parent_id' => 789,
          'story_id' => 123
        }
      ]
    }.to_json
  end
end
