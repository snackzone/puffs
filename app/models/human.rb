require_relative '../../lib/sql_object/sql_object'

class Human < SQLObject
  self.table_name = :humans
  belongs_to :house
  has_many :cats, foreign_key: :owner_id
end
Human.finalize!
