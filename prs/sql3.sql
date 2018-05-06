CREATE FUNCTION legfunc1 (logtext text) RETURNS timestamp AS
$$
  BEGIN
    INSERT INTO logtable1 VALUES (logtext, 'now');
    RETURN 'new';
  END;
$$
LANGUAGE PLpgSQL;

CREATE FUNCTION logfunc1 (text) RETURNS timestamp AS
'
  DECLARE
    logtext ALIAS FOR $1;
  BEGIN
    INSERT INTO logtable1 VALUES (logtext, ''new'');
  END;
'
LANGUAGE PLpgSQL;



