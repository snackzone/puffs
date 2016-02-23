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
  houses (id, address)
VALUES
  (1, '26th and Guerrero'),
  (2, 'Dolores and Market'),
  (3, '123 4th Street');

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, 'Devon', 'Watts', 1),
  (2, 'Matt', 'Rubens', 1),
  (3, 'Ned', 'Ruggeri', 2),
  (4, 'Catless', 'Human', 3);

INSERT INTO
  cats (id, name, owner_id)
VALUES
  (1, 'Breakfast', 1),
  (2, 'Earl', 2),
  (3, 'Haskell', 3),
  (4, 'Markov', 3),
  (5, 'Stray Cat', NULL);
