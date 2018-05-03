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

//lang
createdb -E EUC_JP sampledb
SET client_encoding TO 'SJIS';

SHOW client_encoding;
SELECT * FROM customerlist WHERE id < 4;
SET client_encoding TO 'SJIS';
SHOW client_encoding;
SELECT * FROM customerlist WHERE id < 4;

SET client_encoding TO 'SJIS';
SET client_encoding TO 'SJIS'
\encoding SJIS

//VERSION/PLATFORM COMPATIBILITY

//LOCK MANAGEMENT

//CLIENT CONNECTION DEFAULTS

//AUTOVACUUM PARAMETERS

//RUNTIME STATISTICS

//ERROR REPORTING AND LOGGING
ls /usr/local/pgsql/data/pg_log/

//QUERY TUNNING
SET enable_seqscan TO false; 

//WRITE AHEAD LOG

//RESOURCE USAGE

//CONNECTIONS AND AUTHENTICATION

//FILE LOCATIONS
ps ax | grep postmaster | grep -v grep
cat /usr/local/pgsql/data/pid.data
cat /usr/local/pgsql/data/postmaster.pid

//DB USR
CREATE USER user1;
\du

ALTER USER user1 CREATEDB;
\du user1

SELECT SESSION_USER;
SELECT count(*) FROM postgresql_table;
SELECT has_table_privilege('user1', 'postgresql_table', 'select');

GRANT SELECT, UPDATE ON TABLE postgresql_table TO user1 WITH GRANT OPTION;
SELECT SESSION_USER;
SELECT count(*) FROM postgres_table;

GRANT SELECT ON TABLE postgres_table TO user2;
\z postgres_table
SELECT SESSION_USER;
REVOKE UPDATE OR TABLE postgres_table FROM user1;
\z postgres_table
REVOKE SELECT ON TABLE postgres_table FROM user1;
REVOKE SELECT ON TABLE postgres_table FROM user1 CASCADE;
\z

CREATE GROUP group1 WITH USER user1, user2;
\dg
\du user*
CREATE TABLE table_1 (id int);
GRANT ALL PRIVILEGES ON table_1 TO user1;
\z table_1

SELECT SESSION_USER;
SELECT count(*) FROM table_1;
GRANT ALL PRIVILEGES ON table_1 TO GROUP group1;
\z table_1
SELECT SESSION_USER;
SELECT count(*) FROM table_1;
DROP USER user1;

//DB roll
psql -q -U postgres sampledb
CREATE ROLE role1 LOGIN;
\du role*

ALTER ROLE role1 CREATEROLE CREATEDB;
\du role*

SELECT SESSION_USER;
SELECT count(*) FROM postgres_table;
SELECT has_table_privilege('role1', 'postgres_table', 'select');
SELECT SESSION_USER;
GRANT SELECT, UPDATE ON TABLE postgres_table TO role1 WITH GRANT OPTION;
SELECT SESSION_USER;
SELECT count(*) FROM postgresql_table;

GRANT SELECT ON TABLE postgres_table TO role2;
\z postgres_table

REVOKE UPDATE ON TABLE postgres_table FROM role1;
\z postgres_table
REVOKE SELECT ON TABLE postgres_table FROM role1;
REVOKE SELECT ON TABLE postgres_table FROM role1 CASCADE;
\z postgres_table

CREATE ROLE role_a LOGIN INHERIT;
CREATE ROLE role_b LOGIN NOINHERIT IN ROLE role_a;
CREATE ROLE role_c LOGIN INHERIT IN ROLE role_a;
CREATE ROLE role_d LOGIN INHERIT IN ROLE role_b;, role_c;
\du role_*

CREATE ROLE role_a LOGIN INHERIT;
CREATE ROLE role_b LOGIN NOINHERIT;
CREATE ROLE role_c LOGIN INHERIT;
CREATE ROLE role_d LOGIN INHERIT;
GRANT role_a TO role_b;
GRANT role_a TO role_c;
GRANT role_b, role_c TO role_d;

CREATE TABLE table_a (id int);
GRANT ALL PRIVILEGES ON table_a TO role_a;
CREATE TABLE table_b (id int);
GRANT ALL PRIVILEGES ON table_b TO role_b;
GREATE TABLE table_c (id int);
GRANT ALL PRIVILEGES ON table_c TO role_d;

SELECT SESSION_USER;
SELECT has_table_privilege('role_a', 'table_a', 'select') AS table_a,
SELECT has_table_privilege('role_b', 'table_b', 'select') AS table_b,
SELECT has_table_privilege('role_c', 'table_c', 'select') AS table_c;

SELECT SESSION_USER;
SELECT has_table_privilege('role_c', 'table_a', 'select') AS table_a,
       has_table_privilege('role_c', 'table_b', 'select') AS table_b,
       has_table_privilege('role_c', 'table_c', 'select') AS table_c;

SELECT has_table_privilege('role_d', 'table_a', 'select') AS table_a,
       has_table_privilege('role_d', 'table_b', 'select') AS table_b,
       has_table_privilege('role_d', 'table_c', 'select') AS talbe_c;

CREATE ROLE role_1 LOGIN INHERIT;
CREATE ROLE role_2 LOGIN CREATEDB INHERIT ROLE role_1;
\du role_1
\du role_2

psql -q -U role_1 sampledb
SELECT SESSION_USER, CURRENT_USER;
CREATE DATABASE test;

SET ROLE role_2;
SELECT SESSION_USER, CURRENT_USER;
CREATE DATABASE test;

RESET ROLE;
SELECT SESSSION_USER, CURRENT_USER;
DROP ROLE role_1;
DROP ROLE role_2;

//permission
SELECT username, usercreatedb, usesuper, passwd
	FROM pg_user WHERE usename LIKE 'testusr';
SELECT rolename, rolesuper, rolinherit, rolecreaterole,
	rolecreatedb, rolcanlogin, rolcannlimit
	  FROM pg_role WHERE rolename LIKE 'testrole';
ALTER USER user_name CREATEUSER;
ALTER ROLE role_name SUPERUSER;
\du postgres
\z postgres_table
SELECT has_table_privilege('role1', 'postgres_table', 'select');

//pswd
ALTER USER webuser3 WITH ENCRYPTED PASSWORD 'xxxx';
ALTER ROLE webuser3 WITH ENCRYPTED PASSWORD 'xxxx';
SELECT usename, passwd FROM pg_shadow WHERE usename = 'webuser3';
SELECT rolname, rolpassword FROM pg_authid WHERE rolname = 'webuser3';

//client
listen_addresses = 'localhost,192.168.1.10'
tcpip_soket = true

//db create
createdb -E EUC_JP -U postgres sampledb
createdb -h dbms.server.net -E EUC_JP -U postgres sampledb
drop -U postgres sampledb

// contrib/start-scripts
whoami
cp /usr/local/src/postgresql/postgresql-8.1.4/contrib/start-scripts/linux \
/etc/rc.d/init.d/postgresql
chmod 755 /etc/rc.d/init.d/postgresql
/sbin/chkconfig --add postgresql
/sbin/chkconfig postgresql on

whoami
cp /usr/local/src/postgresql/postgresql-8.1.4/start-scripts/freebsd \
/usr/local/etc/rc.d/postgresql
chmod 755 /usr/local/etc/rc.d/postgresql

//pg_ctl stop
pg_ctl stop -D /usr/local/pgsql/data
pg_ctl stop -D /usr/local/pgsql/data -m fast
pg_ctl stop -D /usr/local/pgsql/data
pg_ctl stop -W -D /usr/local/pgsql/data

//pg_ctl start
pg_ctl start -D /usr/local/pgsql/data -l /var/log/postgres/postgresql.log
cat /var/log/postgres/postgresql.log

//pg_ctl
pg_ctl status -D /usr/local/pssql/data

//initdb
initdb --no-locale -D /usr/local/pgsql/data

//
initdb --no-locale -D /usr/local/pgsql/data
pg_ctl start -D /usr/local/pgsql/data
createdb -E EUC_JP sampledb
createdb -E EUC_JP sampledb
psql -U postgres sampledb

