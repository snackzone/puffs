require_relative '../../lib/sql_object/sql_object'

class Cat < SQLObject
  belongs_to :human, foreign_key: :owner_id
  has_one_through :home, :human, :house
end
Cat.finalize!
