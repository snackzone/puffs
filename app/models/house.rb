require_relative '../../lib/sql_object/sql_object'

class House < SQLObject
  has_many :humans
  has_many_through :cats, :humans, :cats
end
House.finalize!
