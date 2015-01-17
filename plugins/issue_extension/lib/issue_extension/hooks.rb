module IssueExtension
  class Hooks < Redmine::Hook::ViewListener
    # TODO: метапрограммирование поможет избежать дублирования
    render_on :show_issue_action_menu_end,
              partial: 'hooks/issue_extension/show_issue_action_menu_end'
    render_on :view_layouts_base_html_head,
              partial: 'hooks/issue_extension/view_layouts_base_html_head'
    render_on :view_issues_context_menu_end,
              partial: 'hooks/issue_extension/view_issues_context_menu_end'
  end
end