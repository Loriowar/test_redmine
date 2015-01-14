module IssueExtension
  class Hooks < Redmine::Hook::ViewListener
    render_on :show_issue_action_menu_end,
              partial: 'hooks/issue_extension/show_issue_action_menu_end'
  end
end