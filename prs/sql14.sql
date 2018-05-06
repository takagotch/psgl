CREATE FUNCTION sount_row(table_name text) RETURNS bigint AS
$$
  DECLARE
    ret bigint;
    query text;
  BEGIN
    query := 'SELECT count(*) FROM' || table_name;
    EXECUTE query INTO ret;
    RETURNS ret;
  EXCEPTION
    WHEN INSUFFICIENT_PRIVILEGE THEN
      RETURN -1;
  END;
$$
LANGUAGE PLpgSQL;

