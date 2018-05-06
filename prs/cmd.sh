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





