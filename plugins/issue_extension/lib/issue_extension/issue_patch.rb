module IssueExtension
  module IssuePatch
    extend ActiveSupport::Concern

    included do
      has_one :additional_option,
              class_name: 'IssueAdditionalOption'

      scope :without_deleted, -> do
        includes(:additional_option).where(issue_additional_options: {is_deleted: [false, nil]})
      end

      # NOTE: очень спорное решение, но перегружать index для issue не лучше
      default_scope do
        unless User.current.admin?
          includes(:additional_option).where(issue_additional_options: {is_deleted: [false, nil]})
          # joins('LEFT OUTER JOIN issue_additional_options AS iao ON issues.id = iao.issue_id').
          #     where('iao.is_deleted = false OR iao.is_deleted IS NULL')
        end
      end
    end

    def deleted?
      Maybe(additional_option).deleted?.or_else{false}
    end

    def mark_as_deleted!
      process_deleted_state!(true, :unable_to_mark_as_deleted)
    end

    def unmark_as_deleted!
      process_deleted_state!(false, :unable_to_unmark_as_deleted)
    end

  private

    def process_deleted_state!(value, error_sym)
      Maybe(additional_option).update_attribute(:is_deleted, value).or_else do
        unless build_additional_option(is_deleted: value).save
          errors.add(:base, l(error_sym, scope: 'issue_extension.errors'))
        end
      end
    end

    module ClassMethods
      #stub
    end
  end
end