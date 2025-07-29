require_relative "../helper"

class GetCommentsTest < Minitest::Test
  def setup
    super
    @tool = Tools::GetComments.new
    @mock_client = Minitest::Mock.new
  end

  def teardown
    @mock_client.verify
  end

  def test_successful_comment_fetching_with_default_depth
    @mock_client.expect(:get_comments, mock_comments, [123, 3])

    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_id: 123)

      assert_values({story_id: 123, max_depth: 3, count: 1}, result)
    end
  end

  def test_successful_comment_fetching_with_custom_depth
    @mock_client.expect(:get_comments, mock_comments, [123, 2])

    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_id: 123, max_depth: 2)

      assert_values({story_id: 123, max_depth: 2, count: 1}, result)
    end
  end

  def test_empty_comments_response
    @mock_client.expect(:get_comments, [], [123, 3])

    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_id: 123)

      assert_values({story_id: 123, count: 0, comments: []}, result)
    end
  end

  def test_client_error_handling
    @mock_client.expect(:get_comments, nil) do |story_id, max_depth|
      raise StandardError, "Network timeout"
    end

    HackerNews::Client.stub(:new, @mock_client) do
      result = @tool.call(story_id: 123)

      assert_includes result[:error], "Network timeout"
    end
  end

  private

  def mock_comments
    [
      HackerNews::Comment.new(
        id: 456,
        by: "user1",
        time: 1609459200,
        text: "Root comment",
        parent: nil,
        replies: [
          HackerNews::Comment.new(
            id: 789,
            by: "user2",
            time: 1609459300,
            text: "Reply 1",
            parent: 456,
            replies: []
          )
        ]
      )
    ]
  end
end
