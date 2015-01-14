class IssueAdditionalOptionsController < ApplicationController

  before_filter :find_issue, only: [:mark_as_deleted, :unmark_as_deleted]

  def mark_as_deleted
    @issue.mark_as_deleted!
    flash[:error] = @issue.errors.full_messages if @issue.errors.any?
    redirect_to :back
  end

  def unmark_as_deleted
    @issue.unmark_as_deleted!
    flash[:error] = @issue.errors.full_messages if @issue.errors.any?
    redirect_to :back
  end
end