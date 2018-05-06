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


