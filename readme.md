Puffs
=====

Puffs is a lightweight MVC with a built-in ORM that allows you to make
updates to a Postgres database without writing much SQL code. Sounds a
little like Rails? Well, let's say Puffs was *inspired* by Rails ;).

How To Do Puffs
---------------

0. Things you need:
  * Ruby
  * Postgres

1. Open command line, enter the following:
2. gem install puffs
3. puffs new [name of your app]
4. puffs db create
5. You're all set!

Enter 'puffs' into the command line with no arguments to see the full
list of commands, or just read them below:

* puffs new [app name]
* puffs server
* puffs generate
  * model [model name]
  * controller [controller name]
  * migration [migration name]
* puffs db
  * create
  * migrate
  * seed
  * reset

Demo App
--------

As you explore this document, you may find it helpful to reference the
SamplePuffsApp on the puffs Github repo to see how everything connects.

The Puffs ORM
-------------

Puffs' object relational mapping is inspired by Rails' ActiveRecord.
It converts tables in a Postgres database into instances of the
Puffs::SQLObject class.

Puffs::SQLObject is a very lightweight version of ActiveRecord::Base.
It's a great way to use ActiveRecord::Base's CRUD methods and associations
without all the extra overhead.

Puff::SQLRelation imitates the behavior of ActiveRecord::Relation,
making sure no unnecessary queries are made to the DB.

###All of your favorite methods are present, including:
* Create
* Find
* All
* Update
* Destroy

###Also builds Rails table associations:
* Belongs to
* Has many
* Has one through
* Has many through

##Puffs::SQLRelation
Has the basic functionality of ActiveRecord::Relation, allowing us to
order and search DB entries with minimal querying.

All methods are lazy and stackable. Queries are only fired when SQLRelation#load
is called or when the relation is coerced into an Array.

###Methods included:
  * All
  * Where
  * Includes
  * Find
  * Order
  * Limit
  * Count
  * First
  * Last

###Eager loading reduces queries
* Preload has_many and belongs_to associations by calling SQLObject#includes
  * Lazy and chainable.
  * Reduces your DB queries from (n + 1) to 2.

Database
--------

The Puffs commands prefixed with 'db' interact with the Puffs Postgres database.
* 'puffs db create' drops any Postgres DB named 'Puffs' and creates a new,
  empty one.
* 'puffs db migrate' finds and any SQL files under db/migrate that have not
  been migrated and copies them into the DB.
* 'puffs db seed' calls Seed::populate in db/seeds.rb, allowing you
  to quickly reset your DB to a seed file while in development.
* 'puffs db reset' executes all three of the above commands, saving you
  time and energy!

Puffs::ControllerBase
---------------------

The Puffs::ControllerBase connects your models to your routes, allowing
access to the DB through html.erb views. It's how Puffs takes over the Web.

Router
------

Routes live in config/routes.rb. New routes are written using Regex.
Open a server connection with the 'puffs server' command.

Puffs Console
-------------

Access your DB with Puffs::SQLObject methods by simply entering
"require 'puffs'" in Pry (or IRB).
