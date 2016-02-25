class User < Puffs::SQLObject
  has_many :posts, foreign_key: :author_id
  has_many :authored_comments, foreign_key: :commenter_id
  has_many_through :comments, :posts, :comments
end
User.finalize!
