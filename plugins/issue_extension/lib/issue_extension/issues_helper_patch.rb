module IssueExtension
  module IssuesHelperPatch
    extend ActiveSupport::Concern

    included do
      def link_to_mark_as_deleted(issue = @issue)
        link_to l(:mark_as_deleted, scope: 'issue_extension.links'),
                url_for(controller: :issue_additional_options,
                        action: :mark_as_deleted,
                        id: issue.id),
                class: 'icon icon-del'
      end

      def link_to_unmark_as_deleted(issue = @issue)
        link_to l(:unmark_as_deleted, scope: 'issue_extension.links'),
                url_for(controller: :issue_additional_options,
                        action: :unmark_as_deleted,
                        id: issue.id),
                class: 'icon icon-reload'
      end

      def link_to_destroy(issue = @issue)
        link_to l(:permanently_remove, scope: 'issue_extension.links'),
                issue_path(issue),
                data: {confirm: issues_destroy_confirmation_message(issue)},
                method: :delete,
                class: 'icon icon-del'
      end
    end

    module ClassMethods
      #stub
    end
  end
end