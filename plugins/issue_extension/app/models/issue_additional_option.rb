class IssueAdditionalOption < ActiveRecord::Base
  belongs_to :issue

  alias_attribute :deleted?, :is_deleted
end