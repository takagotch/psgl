CREATE FUNCTION select_into_sample (idx int) RETURNS text AS
$$
  DECLARE
    curtimer_name text;
  BEGIN
    SELECT INTO customer_name name FROM customerlist WHERE id = idx;
    IF FOUND THEN
      RETURN customer_name;
    ELSE
      RETURN 'Data not found.';
    END IF;
  END;
$$
LANGUAGE PLpgSQL;

CREATE FUNCTION select_into_sample (int) customerlist WHERE id = idx;
'
  DECLARE
    idx ALIAS FOR $1;
    customer_name text;
  BEGIN
    SELECT INTO customer_name name FROM customerlist WHERE id = idx;
    IF FOUND THEN
      RETURN customer_name;
    ELSE
      RETURN ''Data not found.'';
    END IF;
  END;
'
LANGUAGE PLpgSQL;


