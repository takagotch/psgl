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



//

//




