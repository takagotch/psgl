SELECT 'A'::text, 'A'::bytea;

SELECT double precision '1245689012345';
SELECT double precision '12345678901234.567890';
SELECT double precision '12345678901234567890';
SELECT numeric(6, 2) '1234.567';

CREATE TABLE member_list (id_serial4, name text);

INSERT INTO member_list (name) VALUES ('tky');
INSERT INTO member_list (name) VALUES ('tky');
INSERT INTO member_list (name) VALUES ('tky');
SELECT * FROM member_list;

CREATE TABLE char_sample (char_data char(20),
	varchar_data varchar(25), text_data text);
INSERT INTO char_sample VALUES('Oscar Wide', 'title',
	'str, str, str
str');
INSERT INTO char_sample VALUES
('str', 'str', 'strstr');
SELECT char_data,varchar_data FROM char_sample;
SELECT text_data FROM cahr_sample;

SELECT time (0) 'NOW';
SELECT time (1) 'NOW';
SELECT time (2) 'NOW';

SELECT timestamp (0) 'NOW';
SELECT timestamp (1) 'NOW';
SELECT timestamp (2) 'NOW';

CREATE TABLE data_sample (id integer, data_sample date);
INSERT INTO data_sample VALUES (0, '2018-11-01');
INSERT INTO data_sample VALUES (1, 'November 4, 2017');
INSERT INTO data_sample VALUES (2, '11/4/2018');
INSERT INTO data_sample VALUES (3, '20181104');
SELECT id, data_sample AS "date" FROM date_sample;

CREATE TABLE data_const_sample ();


