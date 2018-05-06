telang plpgsql -d sampledb

SELECT * FROM get_customer_data(1);
SELECT get_customer_name(1);

SELECT get_customer_name(1);

SELECT logfunc1('logfunc1 :1');
SELECT logfunc1('logfunc1 :2');
SELECT logfunc1('logfunc1 :3');
SELECT * FROM logtable1;

SELECT logfunc2('logfunc2 :1');
SELECT logfunc2('logfunc2 :2');
SELECT logfunc2('logfunc2 :3');
SELECT * FROM logtable2;

SELECT select_into_sample(1);
SELECT select_into_sample(-1);

SELECT * FROM itemlist;
SELECT change_all_price('itemlist', 1.05);
SELECT * FROM itemlist;

SELECT count_rows('itemlist');
SELECT count_rows('customerlist');


SELECT get_season(4) AS "season";
SELECT get_season(11) AS "season";


SELECT * FROM item_names ();
SELECT item_names();

SELECT * FROM item_names();


SELECT * FROM item_names();


SELECT * FROM item_names();

SELECT * FROM item_names();

SELECT * FROM itemlist;



