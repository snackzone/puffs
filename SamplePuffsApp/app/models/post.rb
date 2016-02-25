class Post < Puffs::SQLObject
  belongs_to :user
  has_many :comments
end
Post.finalize!
