unbound_cursor refcursor;
bound_cursor1 CURSOR FOR SELECT * FROM customerlist;
bound_cursor2 CURSOR (lower integer, upper integer)
  FOR SELECT * FROM customerlist WHERE id BETWEEN lower AND upper;

OPEN unbound_cursor1 FOR SELECT * FROM customerlist;
OPEN unbound_cursor2 FOR EXECUTE 'SELECT * FROM' || quote_ident($1);

OPEN bound_cursor1;
OPEN bound_cursor2(1,5);

FETCH cursor INTO customer_data;
FETCH cursor INTO id, name, companycode;


