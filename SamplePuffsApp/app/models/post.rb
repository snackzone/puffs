class Post < Puffs::SQLObject
  belongs_to :user, foreign_key: :author_id
  has_many :comments
end
Post.finalize!
