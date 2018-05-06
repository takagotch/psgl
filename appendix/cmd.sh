SELECT * FROM customerlist; SELECT count(*) FROM customerlist;

SELECT * FROM customerlist;

ps ax | grep syslogd | grep -v grep
kill -HUP 515

pg_ctl -D /usr/local/pgsql/data reload



cat /pro/sys/kernel/shmax
echo 67108864 > /proc/sys/kernel/shmax
cat /proc/sys/kernel/shmax

cat /proc/sys/kernel/sem
echo 250 35000 32 256 > /proc/sys/kernel/sem
cat /proc/sys/kernel/sem

cat /proc/sys/fs/file-max
echo 24576 > /proc/sys/fs/file-max

SELECT pg_tablespace_size('pg_global');
SELECT pg_database_size('sampledb');
SELECT pg_relation_size('test');
SELECT pg_total_relation_size('test');

ce ./contrib/dbsize
gmake
gmeke install

psql -U postgres sampledb -f dbsize.sql

psql -U postgres -q sampledb
SELECT database_size('sampledb');

SELECT database_size('customer');

SELECT relation_size('accounts');
SELECT relation_size('itemlist');

cd ./contrib/pgbench
gmake
gmake install

./pgbench -i sampledb

./pgbench sampledb
