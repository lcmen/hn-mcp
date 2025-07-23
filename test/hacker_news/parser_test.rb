class TestParser < Minitest::Test
  def test_parse_stories
    story_data = [
      {
        "objectID" => 123,
        "title" => "First Story",
        "url" => "https://example.com/1",
        "points" => 42,
        "_tags" => ["story"]
      },
      {
        "objectID" => 124,
        "title" => "Second Story",
        "url" => "https://example.com/2",
        "points" => 35,
        "_tags" => ["story"]
      },
      nil  # Should be filtered out
    ]

    stories = HackerNews::Parser.parse_stories(story_data)

    assert_equal 2, stories.length
    assert_all_instance_of HackerNews::Story, stories
    assert_attributes({
      id: 124,
      title: "Second Story",
      url: "https://example.com/2",
      score: 35,
      type: "story"
    }, stories.last)
    assert_equal [], HackerNews::Parser.parse_stories([])
  end

  def test_parse_comments
    comment_data = [
      {
        "objectID" => 456,
        "author" => "user1",
        "comment_text" => "First comment",
      },
      {
        "objectID" => 457,
        "author" => "user2",
        "comment_text" => "Second comment",
      },
      {
        "objectID" => 458,
        "author" => "user3",
        "comment_text" => "Deleted comment",
        "deleted" => true,
      },
      {
        "objectID" => 459,
        "author" => "user4",
        "comment_text" => "Dead comment",
        "dead" => true,
      }
    ]

    assert_equal [], HackerNews::Parser.parse_comments([])
    assert_equal [], HackerNews::Parser.parse_comments(nil)

    comments = HackerNews::Parser.parse_comments(comment_data)

    assert_equal 2, comments.length # Deleted and dead comments filtered out
    assert_all_instance_of HackerNews::Comment, comments
    assert_attributes({
      id: 456,
      by: "user1",
      text: "First comment",
      parent: nil,
      reply_count: 0
    }, comments.first)
    assert_attributes({
      id: 457,
      by: "user2",
      text: "Second comment",
      parent: nil,
      reply_count: 0
    }, comments.last)
  end

  def test_parse_comments_with_nested_replies_and_depth
    nested_comment_data = [
      {
        "objectID" => 456,
        "author" => "user1",
        "comment_text" => "Level 1"
      },
      {
        "objectID" => 789,
        "author" => "user2",
        "comment_text" => "Level 2",
        "parent_id" => 456
      },
      {
        "objectID" => 790,
        "author" => "user3",
        "comment_text" => "Level 3",
        "parent_id" => 789
      }
    ]

    comments = HackerNews::Parser.parse_comments(nested_comment_data)
    assert_equal 1, comments.length
    assert_all_instance_of HackerNews::Comment, comments

    parent = comments.first
    assert_attributes({
      id: 456,
      by: "user1",
      text: "Level 1",
      parent: nil,
      reply_count: 1
    }, parent)
    child = parent.replies.first
    assert_attributes({
      id: 789,
      by: "user2",
      text: "Level 2",
      parent: 456,
      reply_count: 1
    }, child)
    assert_attributes({
      id: 790,
      by: "user3",
      text: "Level 3",
      parent: 789,
      reply_count: 0
    }, child.replies.first)

    comments = HackerNews::Parser.parse_comments(nested_comment_data, 2)
    parent = comments.first
    assert_equal 1, parent.replies.length
    child = parent.replies.first
    assert_equal 0, child.replies.length
  end
end
