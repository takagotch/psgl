//CREATE OPERATOR,DROP OPERATOR
cd ~/src
gmake
cp complex.so /usr/local/pgsql/lib

CREATE FUNCTION complex_add(complex, complex)
  RETURNS complex
  AS '/usr/local/pgsql/lib/complex'
  LANGUAGE C;

CREATE OPERAOR + (
  leftarg = complex,
  rigntarg = complex,
  procedure = complex_add,
  commurator = +);

SELECT comp1, comp2, (comp1 + comp2) AS "comp1 + comp2"
  FROM complex_pair;

DROP OPERATOR + (complex, complex);



//CREATE TYPE,DROP TYPE
CREATE TYPE complex AS(x double precision, y double precision);

cd ~/usr/local/psql/lib
gmake
cp complex.so /usr/local/pgsql/lib

CREATE FUNCTION complex_in(cstring)
  RETURN complex
  AS '/usr/local/pgsql/lib/complex' LANGUAGE C;

CREATE FUNCTION complex_out(complex)
  RETURN cstring
  AS '/usr/local/pgsql/lib/complex' LANGUAGE C;

CREATE TYPE complex (
  internallength = 16,
  input = complex_in,
  out = complex_out);

CREATE TABLE complex_pair (compl complex, comp2 complex);
INSERT INTO complex_pair VALUES('(1.0, 0.0)', '(1.0, 1.0)');
INSERT INTO complex_pair VALUES('(-1.0, -1.0)', '(3.0, 2.0)');
SELECT * FROM complex_pair;

DROP TYPE complex CASCADE;

//CREATE LANGUAGE,DROP LANGUAGE
CREATE FUNCTION plpgsql_call_handler ()
  RETURNS LANGUAGE_HANDLER
  AS '/usr/local/pgsql/lib/plpgsql',
  'plpgsql_call_handler' LANGUAGE C;

CREATE TRUSTED LANGUAGE plpgsql HANDLER plpgsql_call_handler;

DROP LANGUAGE plpgsql CASCADE;

//DROP FUNCTION
DROP FUNCTION update_price(text, integer);


//CREATE FUNCTION
CREATE FUNCTION change_price (text, integer) RETURNS void AS
  $$ /* $1 = name */
     /* $2 = new_price */
     UPDATE itemlist SET price = $2 WHERE name LIKE $1; $$
LANGUAGE SQL;

SELECT change_price ('pen', 120);


CREATE FUNCTION print_itemname_and_price (int) RETURNS record AS
  $$ /* $1 = id */
     SELECT name, price FROM itemlist WHERE id = $1; $$
LANGUAGE SQL;

SELECT print_itemname_and_price(2);

SELECT * FROM print_itemname_and_price (2)
  AS (name text, price integer);


CREATE FUNCTION print_all_items () RETURNS SETOF itemlist AS
  $$ SELECT * FROM itemlist; $$
LANGUAGE SQL;

SELECT print_all_items();

SELECT * FROM print_all_items();


CREATE FUNCTION print_item (int) RETURNS itemlist AS
  $$ /* $1 = id */
     SELECT * FROM itemlist WHERE id = $1; $$
LANGUAGE SQL;

SELECT print_item(2);

SELECT * FROM print_item(2);

CREATE FUNCTION min_price() RETURNS itemlist.price %TYPE AS
  $$ SELECT min(price) FROM itemlist; $$
LANGUAGE SQL;

SELECT min_price();


CREATE FUNCTION change_price (integer, integer) RETURNS void AS
  $$ /* $1 = id */
     /* $2 = new_price */
     UPDATE itemlist SET price = $2 WHERE id = $1; $$
LANGUAGE SQL;

SELECT change_price (1, 120);


CREATE FUNCTION count_item (OUT bigint) AS
  $$ SELECT count(*) FROM itemlist; $$
LANGUAGE SQL;


CREATE FUNCTION count_item() RETURNS bigint AS
  $$ SELECT count(*) FROM itemlist; $$
LANGUAGE SQL;

SELECT count_item();



CREATE FUNCTION upper_80 () RETURNS bigint AS
$$ SELECT count(*) FROM itemlist; $$
LANGUAGE SQL;

CREATE FUNCTION lower_74 () RETURNS bigint AS
'SELECT count(*) FROM itemlist;'
LANGUAGE SQL;

CREATE FUNCTION change_price (integer, integer) RETURNS void AS ...
CREATE FUNCTION change_price (IN integer, IN integer) AS ...

CREATE FUNCTION print_item (integer) RETURNS itemlist AS ...
CREATE FUNCTION print_item (IN integer, OUT itemlist) AS ...

CREATE FUNCTION double_num (integer) RETURNS integer AS ...
CREATE FUNCTION double_num (INOUT integer) AS ...

//CREATE RULE, DROP RULE
CREATE TABLE itemlist_log (name text, old_price integer,
		new_price integer, update_time timestamp);

CREATE RULE update_itemlist_rule AS ON UPDATE TO itemlist DO
		INSERT INTO itemlist_log VALUES
		  (NEW.name, OLD.price, NEW.price, CURRENT_TIMESTAMP);

UPDATE itemlist SET price = 300 WHERE name = 'notebook';

SELECT * FROM itemlist_log;


SELECT rulename FROM pg_rules;

SELECT rulename, definition FROM pg_rules
		WHERE rulename = 'update_itemlist_rule';

CREATE RULE raise_price_itemlist_rule AS ON UPDATE TO itemlist
	WHERE OLD.price < NEW.price DO
		INSERT INTO itemlist_log VALUES
		  (NEW.name, OLD.price, NEW.price, CURRENT_TIMESTAMPS);

DROP RULE update_itemlist_rule ON itemlist;

CREATE VIEW myview AS SELECT * FROM mytable;

CREATE TABLE myview ("mytable SAME");
CREATE RULE "_RETmyview" AS ON SELECT TO myview DO INSTEAD SELECT * FROM mytable;

//COPY TO
SELECT * FROM customerlist;

COPY customerlist TO '/home/postgres/customerlist.txt';

cat /home/postgres/customerlist.txt

COPY customerlist TO '/home/postgresql/customerlist.bin' BINARY;

SELECT * FROM literature;

COPY literature TO '/home/postgres/literature.csv' CSV HEADER FORCE QUOTE title, auther, context;

cat /home/postgres/literature.csv

//COPY FROM
cat /home/postgres/customerlist.txt

COPY customerlist FROM '/home/postgres/customerlist.txt';

od -c /home/postgres/customerlist.bin

COPY customerlist FROM '/home/postgres/customerlist.bin' BINARY;

SELECT * FROM customerlist;

cat /home/postgres/literature.csv

COPY literature FROM '/home/postgres/literature.csv' CSV HEADER;

SELECT * FROM literature ;

//EXPLAIN
EXPLAIN SELECT * FROM all_customers;

SELECT relname, relpages FROM pg_class
WHERE relname = 'all_customers';

//EXPLAIN
EXPLAIN SELECT * FROM customerlist;
EXPLAIN SELECT a.id, a.name, b.cmpany
	FROM customerlist AS a, companylist AS b
		WHERE a.companycode = b.companycode;

//ANALYZE
ANALYZE;

//VACUUM
VACUUM;
VACUUM ANALYZE;

//RESET
RESET enable_seqscan;
SHOW enable_seqscan;


//SHOW
SHOW enable_seqscan;
SHOW ALL;

//SET
SET enable_seqscan TO OFF;
SHOW enable_seqscan;
SET commit_delay = 1000;
SHOW commit_delay;

//LOCK
BEGIN;
LOCK itemlist INEXCUSIVE MODE;
UPDATE itemlist SET price = 75 WHERE id = 3;
END;

LOCK itemlist INACCESS SHARE MODE;

BEGIN;
LOCK itemlist IN EXCLUSIVE MODE;
UPDATE itemlist SET price = 75 WHERE id = 3;
END;

LOCK itemlist IN ROW EXCLUSIVE MODE;

BEGIN;
LOCK itemlist IN EXCLUSIVE MODE;
UPDATE itemlist SET price = 75 WHERE id = 3;
END;

LOCK itemlist IN ROW EXCLUSIVE MODE NOWAIT;

//PREPARE TRANSACTION
BEGIN;
PREPARE TRANSACTION 'mission-02';
SELECT * FROM pg_prepared_xacts;
COMMIT PREPARED 'mission-01';
SELECT * FROM pg_prepared_xacts;

//SET CONSTRAINTS

//SAVEPOINT
BEGIN;
INSERT INTO savepoint_test VALUES (0, 'savepointSETBACK');
SAVEPOINT sp1;
INSERT INTO savepoint_test VALUES (1, 'savepointSETPREV');
SAVEPOINT sp2;
INSERT INTO savepoint_test VALUES (2, 'savepointSETBACK');
SAVEPOINT sp3;
INSERT INTO savepoint_test VALUES (3, 'savepointSETPREV');
SELECT * FROM savepoint_test;

ROLLBACK TO SAVEPOINT sp2;
SELECT * FROM savepoint_test;

INSERT INTO savepoint_test VALUES (4, 'savepointROLLBACKBACK');
COMMIT;

SELECT * FROM savepoint_test;

BEGIN;
DECLARE pref CURSOR FOR SELECT * FROM prefecture ORDER BY id;

FETCH IN pref;

SAVEPOINT sp1;

FETCH FORWARD 6 IN pref;

ROLLBACK TO SAVEPOINT sp1;
FETCH IN pref;

//SET TRANSACTION ISOLATION LEVEL, SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL

//BEGIN:START TRANSACTION, COMMIT: END, ABORT: ROLLBACK
SELECT id, name, price FROM item.list;
BEGIN;
UPDATE itemlist SET price = 80 WHERE id = 3;
COMMIT;
SELECT id, name, price FROM itemlist;
BEGIN;
UPDATE itemlist SET price = 130 WHERE id = 3;
COMMIT;


START TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SHOW TRANSACTION ISOLATION LEVEL;
BEIGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SHOW TRANSACTION ISOLATION LEVEL;

BEGIN ISOLATION LEVEL SERIALIZABLE;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SHOW TRANSACTION ISOLATION LEVEL;

BEGIN ISOLATION LEVEL SERIALIZABLE;
SHOW TRANSACTION ISOLATION LEVEL;

//PREPARE, EXECUTE, DEALLOCATE
PREPARE count_customer AS SELECT count(*) FROM customerlist;
EXECUTE count_customer;
PREPARE select_customer(integer)
  AS SELECT * FROM customerlist WHERE id = $1;
EXECUTE select_customer(1);
EXECUTE select_customer(2);
DEALLOCATE select_customer;

//MOVE
BEGIN;
DECLARE pref CURSOR FOR SELECT * FROM prefecture ORDER BY id;
MOVE 13 IN pref;
FETCH IN pref;

MOVE BACKWARD 8 IN pref;
FETCH IN pref;
MOVE LAST IN pref;
FETCH RELATIVE 0 IN pref;

MOVE ALL IN pref;
FETCH RELATIVE 0 IN pref;
FETCH IN pref;
FETCH BACKWARD 1 IN pref;

MOVE BACKWARD ALL IN pref;
FETCH IN pref;

MOVE 1000 IN pref;

//FETCH
DECLARE pref CURSOR FOR SELECT * FROM prefecture ORDER BY id;
FETCH IN pref;

FETCH FORWARD 6 IN pref;

FETCH RELATIVE 0 IN pref;
FETCH FORWARD 0 IN pref;
FETCH BACKWARD 0 IN pref;

FETCH BACKWARD 3 IN pref;

FETCH NEXT IN pref;

//DECLARE, CLOSE
BEGIN;
DECLARE pref CURSOR FOR SELECT * FROM prefecture ORDER BY id;

BEGIN;
DECLARE view_cursor CURSOR FOR
  SELECT * FROM customer_view ORDER BY id;

BEGIN;
DECLARE maker_cursor CURSOR FOR SELECT * FROM makerlist;
DECLARE maker_cursor CURSOR FOR SELECT * FROM itemlist;

BEGIN;
DECLARE pref CURSOR WITH HOLD FOR SELECT * FROM prefecture ORDER BY id;
FETCH 6 IN pref;
COMMIT;
FETCH 6 IN pref;

//CURSOR
BEGIN;
DECLARE pref CURSOR FOR SELECT * FROM prefecture ORDER BY id;

FETCH FORWARD IN pref;

FETCH FORWARD 6 IN pref;

MOVE BACKWARD 3 IN pref;
FETCH FORWARD 4 IN pref;

CLOSE pref;
COMMIT;

//CREATE TRIGGER, ALTER TRIGGER, DROP TRIGGER
CREATE TABLE number_of_item (count bigint);
INSERT INTO number_of_items (count) SELECT count(*) FROM itemlist;
CREATE FUNCTION count_number_of_item () RETURNS trigger AS
  $$
    DECLARE
    BEGIN
      UPDATE number_of_items SET count = (SELECT count (*) FROM itemlist);
      RETURN NULL;
    END;
  $$
LANGUAGE plpgsql;

CREATE TRIGGER update_number_of_item AFTER INSERT OF DELETE
  ON itemlist FOR EACH ROW
    EXECUTE PROCEDURE count_number_of_item ();

SELECT * FROM number_of_items;
INSERT INTO itemlist VALUES (4, 'book',2890, 85);

SELECT * FROM number_of_items;

CREATE TABLE itemlist_log (name test, old_price int, new_price int);
CREATE FUNCTION insert_itemlist_log() RETURNS trigger AS
  $$
    DECLARE
    BEGIN
      INSERT INTO itemlist_log VALUES(NEW.name, OLD.price, NEW.price);
      RETURN NULL;
    END;
  $$
LANGUAGE plpgsql;

CREATE TRIGGER itemlist_logging AFTER UPDATE
  ON itemlist FOR EACH ROW
    EXECUTE PROCEDURE insert_itemlist_log();

SELECT * FROM itemlist_log();

CREATE TABLE count_update (row int, statement int);
INSERT INTO count_update VALUES (0, 0);
CREATE FUNCTION count_update_row() RETURNS trigger AS
  $$
    DECLARE 
    BEGIN
      UPDATE count_update SET row = row + 1;
      RETURN NULL;
    END;
  $$
LANGUAGE plpgsql;

CREATE FUNCTION count_update_statement() RETURNS trigger AS
  $$
    DECLARE
    BEGIN
      UPDATE count_update SET satement = statement + 1;
      RETURN NULL;
    END;
  $$
LANGUAGE plpgsql;

UPDATE itemlist SET price = 120 WHERE id = 1;
UPDATE itemlist SET price = floor(price * 1.1);
SELECT * FROM count_update;

ALTER TRIGGER companycode_check ON customerlist RENAME TO check_cc;
DROP TRIGGER update_number_of_items ON itemlist;

//CREATE SEQUENCE, ALTER SEQUENCE, DROP SEQUENCE
\ds
CREATE SEQUENCE customerid;
INSERT INTO customerlist VALUES (nextval('customerid'), 'TKY', 4);
INSERT INTO customerlist VALUES (nextval('customerid'), 'takagotch', 2);
SELECT * FROM customerlist;

CREATE SEQUENCE seq)limit MINVALUES 999999999999999999 NO CYCLE;
SELECT nextval ('seq_limit');
SELECT nextval ('seq_limit');
SELECT nextval ('seq_limit');

CREATE SEQUENCE seq_cycle INCREMENT 15
                MINVALUES 0 MAXVALUES 30
		START 0
		CYCLE;
SELECT nextval ('seq_cycle');
SELECT nextval ('seq_cycle');
SELECT nextval ('seq_cycle');
SEELCT nextval ('seq_cycle');

CREATE SEQUENCE seq_text;
SELECT nextval('seq_test');
SELECT setval('seq_test', 10);
SELECT nextval('seq_test');

ALTER SEQUENCE seq_test RESTART WITH 10;
SELECT nextval('seq_test');

DROP SEQUENCE seq_setval;

//CREATE VIEW, DROP VIEW
CREATE VIEW mini_customerlist (id, customer_name)
  AS SELECT id, name FROM customerlist;

SELECT * FROM mini_customerlist WHERE id < 4;

CREATE VIEW customer_view (id, name, companyname) 
  AS SELECT a.id, a.name, b.company
    FROM customerlist AS a, companylist AS b
      WHERE a.company_view WHERE id < 4;
SELECT * FROM customer_view WHERE id < 4;
DROP VIEW mini_custoemrlist;
\dv
\d customer_view;

//DROP INDEX
DROP INDEX test_index;

//ALTER INDEX
\d customerlist
ALTER INDEX name_idx RENAME TO customerlist_idx;
\d customerlist

//Bitmap Scan
\d bm_test
SELECT a,b FROM bm_test WHERE a = 900 AND b = 1804;
SELECT a,b FROM bm_test WHERE a = 900 OR b = 1804;

EXPLAIN SELECT a,b FROM bm_test WHERE a = 900  AND b = 1804;
EXPLAIN SELECT a,b FROM bm_test WHERE a = 900 OR b = 1804;

EXPLAIN SELECT a,b FROM bm_test WHERE a = 900 AND b = 1804;
EXPAIN SELECT a,b FROM bm_test WHERE a = 900 OR b = 1804;

SELECT a,b FROM bm_test WHERE a = 900 OR b = 1804;
SET enable_bitmapscan TO false;
SELECT a,b FROM bm_test WHERE a = 900 OR b = 1804;

//B-TREE, GIST, R-TREE, HASH

// CREATE INDEX
CREATE INDEX idx ON table (a, b, c);

CREATE INDEX name_idx ON customerlist (name);

CREATE INDEX multicolumn_idx ON album_list;
  USING BTREE (artist, title);
\d album_list

SELECT * FROM album_list WHERE artist = 'tky' AND title = 'AAA';
SELECT * FROM album_list WHERE artist = 'takagotch' AND title = 'BBB';

SELECT * FROM my_class WHERE id < 5;

CREATE INDEX myclass_name_idx ON my_class (lower(name));
\d my_class

SELECT * FROM my_class WHERE lower(name) = 'tky';

CREATE INDEX special_ids ON customerlist (id)
  WHERE 50 <= id AND id < 100;

//TRUNCATE
SELECT * FROM itemlist;
TRUNCATE itemlist;
SELECT * FROM itemlist;

//DELETE
DELTE FROM itemlist;
SELECT * FROM itemlist;
DELETE FROM itemlist WHERE price < 100;
SELECT * FROM itemlist;

SELECT * FROM itemlist;
SELECT * FROM makerlist;

DELETE FROM itemlist
  WHERE makercode IN
    (SELECT id FROM makerlist WHERE name = 'TK.Inc');

SELECT * FROM itemlist;

//UPDATE
SELECT name, price FROM itemlist;
UPDATE itemlist SET price = 100;
SELECT name, price FROM itemlist;

UPDATE itemlist SET price = 100 WHERE price < 100  OR name = 'pen';
SELECT name, price FROM itemlist;

SELECT * FROM itemlist;
SELECT * FROM makerlist;

UPDATE itemlist SET price = price * 1.1
  WHERE makercode IN
  (SELECT id FROM makerlist WHERE name = 'TK.Inc');

SELECT * FROM itemlist;

UPDATE itemlist SET price = price * 1.1;
  FROM makerlist
    WHERE makerlist.id = itemlist.makercode
    AND makerlist.name = 'TK.Inc';

SELECT * FROM itemlist;

//CASE
SELECT * FROM itemlist;
SELECT id, CASE WHEN name = 'notebook' THEN 'NOTE'
                WHEN name = 'pen' THEN 'PEN'
		WHEN name = 'eraser' THEN 'ERASER'
		ELSE 'OTHER'
	END AS itemname
FROM itemlist;

SELECT name, CASE WHEN price < 100 THEN floor(price * 0.9)
  ELSE floor(price * 0.8)
END AS TODAYPRICE
FROM itemlist;

//sub_query
SELECT * FROM table_1 WHERE
  EXSIST (SELECT * FROM table_2 WHERE table_1.column = table_2.column);

SELECT * FROM comic_list;

SELECT * FROM author_list;

SELECT * FROM comic_list WHERE author_id
  = (SELECT author_id FROM author_list WHERE name = 'tky');

SELECT * FROM comic_list AS c
  WHERE c.author_id IN (SELECT author_id FROM author_list);

SELECT * FROM comic_list AS c
  WHERE c.author_id NOT IN (SELECT author_id FROM author_list);

SELECT * FROM comic_list AS c
  WHERE EXSISTS (SELECT * FROM author_list WHERE c.author_id = author_id);

SELECT title, name FROM (SELECT * FROM author_list) AS a,
  comic_list AS c WHERE a.author_id = c.author_id;

SELECT * FROM comic_list AS c
  WHERE c.author_id = ANY (SELECT author_id FROM author_list);

SELECT * FROM comic_list AS c
  WHERE c.author_id <> ALL (SELECT author_id FROM author_list);

//FOR UPDATE, FOR SHARE
BEGIN;
SELECT price FROM itemlist WHERE id = 1
FOR UPDATE;
UPDATE itemlist SET price = 140 WHERE id = 1;
END;

BEGIN;
SELECT price FROM itemlist WHERE id = 1;
DELETE FROM itemlist WHERE id = 1;
END;

BEGIN;
SELECT price FROM SET price = 140 WHERE id = 1;
COMMIT;

BEGIN;
SELECT price FROM itemlist WHERE id = 1;
FOR SHARE;
DELETE FROM itemlist WHERE id = 1;

BEGIN;
SELECT price FROM itemlist WHERE id = 1
FOR SHARE;
UPDATE itemlist SET price = 140 WHERE id = 1;
COMMIT;

BEGIN;
SELECT price FROM itemlist WHERE id = 1;
FOR SHARE;
COMMIT;

//LIMIT, OFFSET
SELECT * FROM customerlist;
SELECT * FROM customerlist ORDER BY id OFFSET 2 LIMIT 3;

//ORDER BY
SELECT * FROM customerlist WHERE id < 5 ORDER BY id;
SELECT * FROM customerlist WHERE di < 5 ORDER BY id DESC;
SELECT * FROM test_result ORDER BY (math + english + physics);
SELECT * FROM customerlist WHERE id < 5 ORDER BY id USING >;

//UNION, INTERSECT, EXCEPT
SELECT * FROM english_club;
SELECT * FROM footboll_club;

(SELECT name, grade AS "class" FROM english_club) UNION (SELECT name, class FROM football FROM footboll_club);
(SELECT name, grade AS "class" FROM english_club) INTERSECT (SELECT name, class FROM footboll_club);
(SELECT name, grade AS "class" FROM english_club) EXCEPT (SELECT name, class FROM footboll_club);

//CROSS JOIN, JOIN
SELECT * FROM comic_list;
SELECT * FROM author_list;

SELECT * FROM comic_list CROSS JOIN author_list;

SELECT title, name FROM comic_list NATURAL
  INNNER JOIN author_list;

SELECT c.title, a.name FROM comic_list AS c INNER JOIN
  author_list AS a ON (c.author_id = a.author_id);

SELECT title, name FROM comic_list INNER JOIN author_list AS a
  (author_id) USING (author_id);

SELECT title, name FROM comic_list AS c LEFT OUTER JOIN
  author_list AS a ON (c.author_id = a.author_id);

SELECT title, name FROM comic_list AS c RIGHT OUTER JOIN
  author_list AS a ON (c.author_id = a.author_id);

SELECT title, name FROM comic_list AS c FULL OUTER JOIN
  author_list AS a ON (c.author_id = a.author_id);

//DISTINT
SELECT * FROM club_member;
SELECT DISTINCT last_name FROM club_member;

SELECT DISTINCT first_name, last_name FROM club_member;
SELECT DISTINCT ON (frist_name, last_name) * FROM club_member;

//GROUP BY, HAVING
SELECT orderid AS "ordernumber", item_id AS "itemnumber", orders AS "orderamount"
  FROM orderlist;

SELECT item_id AS "itemnumber", count(*) AS "numberoforder" FROM orderlist
  GROUP BY item_id;

SELECT item_id AS "itemnumber", sum(orders) AS "totalorder" FROM orderlist
  GROUP BY item_id;

SELECT * FROM test_result;

SELECT sum(math + english + physics) AS "totalscore",
  count(*) AS "numberofpeople" FROM test_result
    GROUP BY math + english + phsics;

SELECT round((math + english + physics)/3) AS "average",
  count(*) AS "numberofpeople" FROM test_result
    GROUP BY round((math + english + physics)/3);

SELECT item_id AS "itemnumber", count(*) AS "numberoforder" FROM orderlist
  GROUP BY item_id HAVING 2 <= count(*) ;

//WHERE
SELECT * FROM author_list WHERE 1 <= author_id AND author_id <= 3;

SELECT * FROM queen WHERE solo IS NULL;

SELECT * FROM queen WHERE name LIKE '%May';

SELECT * FROM author_list WHERE author_id BETWEEN 1 AND 3;

SELECT * FROM author_list WHERE author_id IN (1,3,5);

//FROM
SELECT author.name, comic.title FROM
  author_list AS author, comic_list AS comic
    WHERE author.author_id = comic.author_id;

//SELECT, sub_query,CASE

//INSERT
INSERT INTO customerlist (id, name, companycode)
  VALUES (1, 'tky', 3);

INSERT INTO customerlist VALUES (2, 'tky', 2);

INSERT INTO new_customerlist (id, name, companycode)
  SELECT id, name, companycode FROM customerlist WHERE id < 5;

//REVOKE
REVOKE SELECT, UPDATE ON companylist FROM webuser;
SELECT has_table_privilege ('webuser', 'companylist', 'SELECT');
SELECT has_table_privilege ('webuser', 'companylist', 'UPDATE');

//GRANT
GRANT USAGE ON SCHEMA postgres TO webuser;
GRANT SELECT ON TABLE customerlist TO webuser;
SELECT has_schema_privilege ('webuser', 'postgres', 'USAGE');
SELECT has_table_privilege('webuser', 'customerlist', 'SELECT');

GRANT CREATE ON DATABASE sampledb TO webuser;
REVOKE ALL ON companylist FROM webuser;
GRANT SELECT, UPDATE ON companylist TO webuser;

GRANT SELECT ON test_table TO user1 WITH GRANT OPTION;
\z test_table

SELECT SESSION_USER;
GRANT SELECT ON test_table TO user2;
\z test_table

//SET SESSION AUTHORIZATION
SELECT CURRENT_USER;
SET SESSION AUTHORIZATION webuser;
SELECT CURRENT_USER;
RESET SESSION AUTHORIZATION;

//ALTER GROUP
ALTER GROUP pcusers ADD USER pc03;
ALTER GROUP pcusers DROP USER pc03;

//DROP GROUP
DROP GROUP pcusers;

//CREATE GROUP
CREATE GROUP pcusers WITH USER pc01, pc02;

//ALTER USER
ALTER USER webuser CREATEDB CREATEUSER;
\dn webuser

//DROP USER
DROP USER webuser;

//CREATE USER
CREATE USER user_name CREATEUSER;
CREATE USER webuser2 CREATEDB CREEATEUSER;
CREATE

//


//


//
//

//

//

//


//

//


//

//


//

//


//


//

//

//

//

//

//

//

//

//

//

//

//

//


//

//

//

//

//

//





//

//

//

//
//



//

//

//

//





















