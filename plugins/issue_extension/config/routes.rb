get 'issues/:id/mark_as_deleted', to: 'issue_additional_options#mark_as_deleted'
get 'issues/:id/unmark_as_deleted', to: 'issue_additional_options#unmark_as_deleted'

# обход конлфликта роутов для "resources :issues"
resources :issue_additional_actions, only: :none do
  collection do
    get :bulk_mark_as_deleted, controller: :issue_additional_options
    get :bulk_unmark_as_deleted, controller: :issue_additional_options
  end
end
