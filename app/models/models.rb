require_relative '../../lib/sql_object/sql_object'

class House < SQLObject
  has_many :humans
  has_many_through :cats, :humans, :cats
end
House.finalize!

class Human < SQLObject
  self.table_name = :humans
  belongs_to :house
  has_many :cats, foreign_key: :owner_id
end
Human.finalize!

class Cat < SQLObject
  belongs_to :human, foreign_key: :owner_id
  has_one_through :home, :human, :house
end
Cat.finalize!
