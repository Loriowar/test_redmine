require File.expand_path('../../test_helper', __FILE__)

class IssueAdditionalOptionTest < ActiveSupport::TestCase
  fixtures :issues, :users, :issue_statuses, :issue_additional_options

  include Redmine::I18n

  def setup
    @deleted_issue = Issue.find(2)
    @restored_issue = Issue.find(1)
    @issue_without_option = Issue.find(3)
  end

  def test_absence_of_additional_option
    assert_nil @issue_without_option.additional_option
  end

  def test_deleted_for_issue_without_option
    assert !@issue_without_option.deleted?
  end

  def test_deleted_for_issue_with_option
    assert @deleted_issue.deleted?
  end

  def test_create
    additional_option = IssueAdditionalOption.new(is_deleted: true, issue_id: @issue_without_option.id)
    assert_save additional_option
    @issue_without_option.reload
    assert @issue_without_option.deleted?
  end

  def test_without_deleted_scope
    all_issue_count = Issue.count
    visible_count = Issue.without_deleted.count
    assert_equal all_issue_count - 1, visible_count
  end

  def test_mark_as_deleted
    @restored_issue.mark_as_deleted!
    assert @restored_issue.deleted?
  end

  def test_unmark_as_deleted
    @deleted_issue.unmark_as_deleted!
    assert !@deleted_issue.deleted?
  end

  def test_init_old_is_deleted
    assert_nil @deleted_issue.old_is_deleted
    @deleted_issue.init_old_is_deleted
    assert @deleted_issue.old_is_deleted
  end

  def test_is_deleted_changed
    @deleted_issue.init_old_is_deleted
    @deleted_issue.additional_option.is_deleted = false
    assert @deleted_issue.is_deleted_changed?
  end

  def test_journal_for_is_deleted
    @restored_issue.stubs(:notified_users).returns([])
    assert @restored_issue.journals.blank?
    @restored_issue.with_journal_for_deleted{|i| i.additional_option.is_deleted = true}
    @restored_issue.reload
    assert_equal @restored_issue.journals.count, 1
    new_details = @restored_issue.journals.last.details
    assert_equal new_details.count, 1
    assert_equal new_details.first.old_value, l(:false_value, scope: 'issue_extension.attr_states.is_deleted')
    assert_equal new_details.first.value, l(:true_value, scope: 'issue_extension.attr_states.is_deleted')
  end

  def test_proper_css_classes_for_deleted
    assert_include 'issue-deleted', @deleted_issue.css_classes(User.find(2))
  end

end