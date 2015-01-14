module IssueExtension
  module ApplicationControllerPatch
    extend ActiveSupport::Concern

    included do
      alias_method_chain :find_issue, :check_deleted
    end

    def find_issue_with_check_deleted
      if User.current.admin?
        find_issue_without_check_deleted
      else
        Issue.without_deleted.scoping do
          find_issue_without_check_deleted
        end
      end
    end

    module ClassMethods
      #stub
    end
  end
end