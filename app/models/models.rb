require_relative 'lib/sql_object'

DEMO_DB_FILE = 'cats.db'
DEMO_SQL_FILE = 'cats.sql'

`rm '#{DEMO_DB_FILE}'`
`cat '#{DEMO_SQL_FILE}' | sqlite3 '#{DEMO_DB_FILE}'`

DBConnection.open(DEMO_DB_FILE)

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
