require File.expand_path('../../test_helper', __FILE__)

class IssueAdditionalOptionsTest < ActionController::IntegrationTest
  fixtures :issues,
           :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :trackers,
           :projects_trackers,
           :enabled_modules,
           :issue_statuses,
           :enumerations,
           :issue_additional_options

  def test_link_to_hide_on_issue_show
    log_user('jsmith', 'jsmith')
    get '/issues/1' # restored issue
    assert_tag :a, attributes: { href: '/issues/1/mark_as_deleted'}
  end

  def test_link_to_restore_on_issue_show
    log_user('admin', 'admin')
    get '/issues/2' # deleted issue
    assert_tag :a, attributes: { href: '/issues/2/unmark_as_deleted'}
  end

  def test_unavailable_show_for_deleted_issue
    log_user('jsmith', 'jsmith')
    get '/issues/2' # deleted issue
    assert_response 404
  end
end