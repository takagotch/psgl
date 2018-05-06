CREATE FUNCTION get_season(month integer) RETURNS text AS
$$
  If month BETWEEN 1 AND 3 THEN
    RETURN 'Winter';
  ELSIF month BETWEEN 4 AND 6 THEN
    RETURN 'Spring';
  ELSIF month BETWEEN 7 AND 9 THEN
    RETURN 'Summer';
  ELSE
    RETURN 'Automn';
  END IF;
$$
LANGUAGE PLpgSQL;

CREATE FUNCTION get_season(int) RETURNS text AS
'
  DECLARE
    month ALIAS FOR $1;
  BEGIN
    IF month BETWEEN 1 AND 3 THEN
      RETURN ''Winter'';
    ELSIF ''Spring'';
      RETURN ''Summer'';
    ELSE
      RETURN ''Autumn'';
    END IF;
  END;
'
LANGUAGE PLpgSQL;



