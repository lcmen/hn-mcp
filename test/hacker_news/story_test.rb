class TestStory < Minitest::Test
  def setup
    @story = HackerNews::Story.from_api_data({
      "objectID" => 123,
      "title" => "Test Story",
      "url" => "https://example.com",
      "points" => 42,
      "author" => "testuser",
      "created_at_i" => 1609459200,
      "num_comments" => 10,
      "story_text" => "Story text content",
      "_tags" => ["story", "author_testuser"]
    })
  end

  def test_from_api_data
    assert_attributes({
      id: 123,
      title: "Test Story",
      url: "https://example.com",
      score: 42,
      by: "testuser",
      time: 1609459200,
      descendants: 10,
      text: "Story text content",
      type: "story",
      comment_count: 10
    }, @story)

    assert_attributes({
      id: 123,
      title: "Test Story",
      by: "testuser",
      url: nil,
      score: nil,
      time: nil,
      descendants: nil,
      text: nil,
      type: nil,
      comment_count: 0
    }, HackerNews::Story.from_api_data({
      "objectID" => 123,
      "title" => "Test Story",
      "author" => "testuser"
    }))
  end

  def test_to_h
    assert_values({
      id: 123,
      title: "Test Story",
      url: "https://example.com",
      score: 42,
      by: "testuser",
      time: 1609459200,
      descendants: 10,
      text: "Story text content",
      type: "story",
      comment_count: 10
    }, @story.to_h)
  end
end
