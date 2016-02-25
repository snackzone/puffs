class Comment < Puffs::SQLObject
  belongs_to :user, foreign_key: :commenter_id
  belongs_to :post
end
Comment.finalize!
