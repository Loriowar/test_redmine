# пока не используется
module ActiveRecordMixins
  class ActiveRecord::Base

    # манкипатч AR для обхода бага с влиянием default_scope на *_all методы
    # баг: https://github.com/rails/rails/issues/3002

    def self.update_all!(*args)
      self.send(:with_exclusive_scope) { self.update_all(*args) }
    end

    def self.delete_all!(*args)
      self.send(:with_exclusive_scope) { self.delete_all(*args) }
    end
  end
end