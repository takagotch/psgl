CREATE FUNCTION new_style (arg1 integer, arg2 text) RETURNS text AS $$ 
BEGIN
RETURN
END;
$$ LaNGUAGE PLpgSQL;

CREATE FUNCTION odl_style (integer, text) RETURN text AS '
  DECLARE
  arg1 ALIAS FOR $1;
  arg2 ALIAS FOR $2;
  BEGIN
	RETURNS '';
  END;
' LANGUAGE PLpgSQL;


