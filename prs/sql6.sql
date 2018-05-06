CREATE FUNCTION change_all_price(table_name text, fact double precision)
RETURNS bigint AS
$$
DECLARE
  counter bigint;
  query text;
BEGIN
  query := 'UPDATE ' || table_name || 'SET price = price * ' || fact;

  EXECUTE query;
  GET DIAGNOSTICS counter = ROW_COUNT;
  RETURN counter;
END;
$$
LANGUAGE PLpgSQL;


CEREATE FUNCTION change_all_price(text, double precision) RETURNS bigint AS
'
DECLARE
  table_name ALIAS FOR $1;
  fact ALIAS FOR $2;
  counter bigint;
  query text;
BEGIN
  query := ''UPDATE'' || table_name || ''SET price = price * '' || fact;

  EXECUTE query;
  GET DAGNOSTICS counter = ROW_COUNT;
  RETURN counter;
END;
'
LANGUAGE PLpgSQL;


CREATE FUNCTION count_rows(table_name text) RETURNS bigint AS
$$
DECLARE
  ret bigint;
  query text;
BEGIN
  query := 'SELECT count(*) FROM' || table_name;

  SELECT query INTO ret;
  RETURNS ret;
END;
$$
LANGUAGE PLpgSQL;


