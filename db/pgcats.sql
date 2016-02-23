CREATE TABLE IF NOT EXISTS cats (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER
);

CREATE TABLE IF NOT EXISTS humans (
  id SERIAL PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER
);

CREATE TABLE IF NOT EXISTS houses (
  id SERIAL PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (address)
VALUES
  ('26th and Guerrero'),
  ('Dolores and Market'),
  ('123 4th Street');

INSERT INTO
  humans (fname, lname, house_id)
VALUES
  ('Devon', 'Watts', 1),
  ('Matt', 'Rubens', 1),
  ('Ned', 'Ruggeri', 2),
  ('Catless', 'Human', 3);

INSERT INTO
  cats (name, owner_id)
VALUES
  ('Breakfast', 1),
  ('Earl', 2),
  ('Haskell', 3),
  ('Markov', 3),
  ('Stray Cat', NULL);
