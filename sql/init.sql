DROP TABLE IF EXISTS author CASCADE ;
CREATE TABLE author
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(256) NOT NULL
);


DROP TABLE IF EXISTS quotation;
CREATE TABLE quotation
(
    id SERIAL PRIMARY KEY,
    content VARCHAR(4128) NOT NULL,
    author_id INTEGER REFERENCES author(id)
        ON DELETE CASCADE
);


CREATE OR REPLACE PROCEDURE insert_author_and_quote( quote_content VARCHAR(2056), author_name VARCHAR(256))
    LANGUAGE plpgsql
AS $$
DECLARE
new_author_id INTEGER;
BEGIN
SELECT id INTO new_author_id FROM author WHERE name = author_name;

IF new_author_id IS NULL THEN
        INSERT INTO author (name) VALUES (author_name) RETURNING id INTO new_author_id;
END IF;

INSERT INTO quotation (content, author_id) VALUES (quote_content, new_author_id);
END; $$;