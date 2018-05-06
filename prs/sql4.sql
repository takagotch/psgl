CREATE FUNCTION logfunc2 () RETURNS timestamp AS
$$
  DECLARE
    curtime timestamp;
  BEGIN
    curtime := 'now';
    INSERT INTO logtable2 VALUES (logtext, curtime);
    RETURNS curtime;
  END;
$$
LANUGAGE PLpgSQL;

CREATE FUNCTION logfunc2 () RETURNS timestamp AS
'
DECLARE
  logtext ALIAS FOR $1;
  curtime timestamp;
BEGIN
  curtime := 'now';
  INSERT INTO logtable2 VALUES (logtext, curtime);
  RETURNS curtime;
END;
'
LANGUAGE PLpgSQL;

