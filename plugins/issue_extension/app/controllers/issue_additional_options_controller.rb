class IssueAdditionalOptionsController < ApplicationController

  before_filter :find_issue, only: [:mark_as_deleted, :unmark_as_deleted]
  before_filter :find_issues, only: [:bulk_mark_as_deleted, :bulk_unmark_as_deleted]

  def mark_as_deleted
    @issue.with_journal_for_deleted{|obj| obj.mark_as_deleted!}
    flash[:error] = @issue.errors.full_messages if @issue.errors.any?
    redirect_to :back
  end

  def unmark_as_deleted
    @issue.with_journal_for_deleted{|obj| obj.unmark_as_deleted!}
    flash[:error] = @issue.errors.full_messages if @issue.errors.any?
    redirect_to :back
  end

  def bulk_mark_as_deleted
    errors = @issues.inject([]) do |h, issue|
      issue.with_journal_for_deleted{|obj| obj.mark_as_deleted!}
      h << issue.errors.full_messages if issue.errors.any?
      h
    end
    flash[:error] = errors if errors.any?
    redirect_to controller: :issues, action: :index
  end

  def bulk_unmark_as_deleted
    errors = @issues.inject([]) do |h, issue|
      issue.with_journal_for_deleted{|obj| obj.unmark_as_deleted!}
      h << issue.errors.full_messages if issue.errors.any?
      h
    end
    flash[:error] = errors if errors.any?
    redirect_to controller: :issues, action: :index
  end
end