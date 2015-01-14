class CreateIssueAdditionalOptions < ActiveRecord::Migration
  def change
    create_table :issue_additional_options do |t|
      t.integer :issue_id
      t.boolean :is_deleted
      t.timestamps
    end

    add_index :issue_additional_options, :issue_id
  end
end
