//pg_stat_activity
SELECT usename, datname, backend_start FROM pg_stat_activity;
SELECT * FROM pg_stat_datebase;
SELECT relname, seq_scan, seq_tup_read, idx_scan, idx_tup_fetch
	FROM pg_stat_all_tables WHERE relname = 'test';
SELECT relname, blks_read, heap_biks_hit, idx_blks_read,
	 idx_blks_hit FROM pg_statio_all_tables WHERE relname = 'that';
SELECT relname, indexrelname, idx_scan, idx_tup_fetch
	FROM pg_stat_all_indexes WHERE relname = 'test';
SELECT relname, indexrelname, idx_blks_read, idx_blks_hit
	FROM pg_statio_all_indexes WHERE relname = 'that';

//Point In Time Recovery
SELECT * FROM pitr_log;
ls -o -t /home/postgres/archivelogs/
pg_ctl -D /usr/local/pgsql/data stop
pwd
cp -rf pg_xlog /home/postgresql/

pwd
cp data/*conf
rm -rf data/

pwd
tar xvfz /home/postgresql/base_backup.tgz
mv *conf data
cd data
rm -f postmaster.pid
rm -rf pg_xlog/
cp -rf /home/postgresql/pg_xlog

pwd
cp ../share/recovery.conf.sample recovery.conf
SELECT * FROM pitr_log;
SELECT * FROM pitr_log;
SELECT * FROM pitr_log;
SELECT * FROM pitr_log;

SELECT * FROM pitr_log;
INSERT INTO pitr_log VALUES (6, current_timestamp, 'Timeline 2');
SELECT * FROM pitr_log;

pg_ctl -D /usr/local/pgsql/data stop
pwd
mv data/pg_xlog pg_xlog.tmp

rm -rf data
rm -rf pg_xlog
mv ../pg_xlog.tmp pg_xlog
rm -f postmaster.pid

INSERT INTO pitr_log VALUES (5, current_timestap, 'Timeline 3');
SELECT * FROM pitr_log;

SELECT * FROM pitr_log;

//archive
mkdir -p /home/postgresql/archivelogs
chmod 700 /home/postgres/archivelogs

pg_ctl -D /usr/local/pgsql/data start

SELECT pg_start_backup ('base backup: test');
cd /usr/local/pgsql/
tar -czf /home/postgres/base_backup.tgz data

SELECT pg_stop_backup ();

ls -o /home/postgres/arhivelogs/
cat /home/postgres/archivelogs/00000000000000000000000000000.000000.backup

//pg_dumpall
pg_dumpall > db.out

initdb -D /usr/local/pgsql/data
pgsql -f db.out templabel

//pg_restore
pg_dump -U postgres -F -c -f sampledb.car sampledb
createdb -U postgres new_sampledb
pg_restore -U postgres -d new_sampledb -F c sampledb.car

createdb -U postgres new_sampledb
psql -U postgres -d new_sampledb -f sampledb.db

//pg_dump
pg_dump -U postgres -f sampledb.db sampledb
createdb -U postgres new_sampledb
psql -U postgres -d new_sampledb -f sampledb.db
pg_dump -U postgres -F c -f sampledb.car sampledb
createdb -U postgres new_sampledb
pg_restore -U postgres -d new_sampledb -F c sampledb.car

pg_dump -U postgres -b -F c -f large_obj.car large_obj
pg_dump -U postgres -f large_obj.db large_obj
pg_dump -U postgres -h dbms.server.net -f sampledb.db sampledb

//table_space
df -H /usr/local/pgsql/data /data/postgres/data
SELECT * FROM pg_tablespace;
CREATE TABLESPACE new_space LOCATION '/data/postgres';
SELECT * FROM pg_tablespace;

pwd
ls

CREATE TABLE new_table (id int, name text) TABLESPACE new_space;
\d new_table
ls
CREATE DATABASE new_db TABLESPACE new_space;
ls

ALTER TABLESPACE new_space RENAME TO dbspace;
\db

DROP DATABASE new_db;
DROP TABLE new_table;
DROP TABLESPACE dbspace;

//VACUUM
contab -u postgres -e

05 4 * * * /usr/local/pgsql/bin/vacuumdb -a -z
30 1 5, 15,25 * * /usr/local/pgsql/bin/vacuum -a -z
30 3 1-3 * 1 /usr/local/pgsql/bin/vacuumdb -a -z

man 1 crontab
man 5 crontab

//vacuumdb
vacuumdb -d sampledb
vacuumdb -a
vacuumdb -a -z
vacuumdb -d sampledb -f

//



