module IssueExtension
  module IssuePatch
    extend ActiveSupport::Concern

    included do
      has_one :additional_option,
              class_name: 'IssueAdditionalOption'

      scope :without_deleted, -> do
        includes(:additional_option).where(issue_additional_options: {is_deleted: [false, nil]})
      end

      attr_reader :old_is_deleted

      # WARNING: очень спорное решение
      # default_scope do
      #   unless User.current.admin?
      #     # NOTE: вариант с includes более опрятный, но есть проблема с первой инициализацией, не видна
      #     #       реляция additional_option при первом вызове
      #     # includes(:additional_option).where(issue_additional_options: {is_deleted: [false, nil]})
      #     joins('LEFT OUTER JOIN issue_additional_options AS iao ON issues.id = iao.issue_id').
      #         where('iao.is_deleted = false OR iao.is_deleted IS NULL').readonly(false)
      #   end
      # end

      alias_method_chain :css_classes, :highlight_deleted

      class << self
        # патч скоупа, дабы избежать множественного переопределения методов IssueQuery
        def visible_with_deleted_processing(*args)
          if User.current.admin?
            visible_without_deleted_processing
          else
            without_deleted.visible_without_deleted_processing
          end
        end

        alias_method_chain :visible, :deleted_processing
      end
    end

    def css_classes_with_highlight_deleted(user = User.current)
      if deleted?
        css_classes_without_highlight_deleted(user) << ' issue-deleted'
      else
        css_classes_without_highlight_deleted(user)
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

    # NOTE: в будущем можно расширить на сохранение целой реляции
    def init_old_is_deleted
      @old_is_deleted = deleted?
    end

    def is_deleted_changed?
      # present? не подходит, ибо Boolean
      !@old_is_deleted.nil? && @old_is_deleted != deleted?
    end

    def with_journal_for_deleted(&block)
      init_old_is_deleted
      instance_eval(&block)
      if is_deleted_changed?
        init_journal(User.current) if @current_journal.blank?
        @current_journal.details << JournalDetail.new(property: 'attr',
                                                      prop_key: :is_deleted,
                                                      old_value: is_deleted_to_s(@old_is_deleted),
                                                      value: is_deleted_to_s)
        @current_journal.save
      end
    end

    def is_deleted_to_s(val = deleted?)
      l("#{val.to_s}_value", scope: 'issue_extension.attr_states.is_deleted')
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