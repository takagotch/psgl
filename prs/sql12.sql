CREATE FUNCTION item_names () RETURNS SETOF text AS
$$
DECLARE
  myname text;
  myrow itemlist%ROWTYPE;
BEGIN
  FOR myrow IN SELECT * FROM itemlist LOOP
    myname := myrow.name;
    RETURN NEXT myname;
  END LOOP;
  RETURN;
END;
$$
LANGUAGE PLpgSQL;


