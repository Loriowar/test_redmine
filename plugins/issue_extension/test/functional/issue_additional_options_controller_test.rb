require File.expand_path('../../test_helper', __FILE__)

class IssueAdditionalOptionsControllerTest < ActionController::TestCase
  fixtures :issues, :projects, :issue_additional_options

  def setup
    User.current = nil
    @issue = Issue.find(1)
  end

  def test_mark_as_deleted
    get :mark_as_deleted, id: @issue.id
    assert_response 302
  end

  def test_unmark_as_deleted
    get :unmark_as_deleted, id: @issue.id
    assert_response 302
  end

  def test_unmark_as_deleted
    get :unmark_as_deleted, id: @issue.id
    assert_response 302
  end

  def test_bulk_mark_as_deleted
    get :bulk_mark_as_deleted, ids: [1, 2]
    assert_response 302
  end

  def test_bulk_unmark_as_deleted
    get :bulk_unmark_as_deleted, id: [1, 2]
    assert_response 302
  end
end