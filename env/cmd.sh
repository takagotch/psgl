//env
source ~/.bashrc
source ~/.cshrc

cat /etc/ld.so.conf
ldconfig

//install
tar xvfz postgresql-8.1.4.tar.gz
cd postgresql-8.1.4

./configure
gmake
cd contrib
gmake
cd ..
su 
pass
mkdir -p /usr/local/pgsql
chown postgres:postgres /usr/local/pgsql
exit

gmake install
cd contrib
gmake install

//
groupadd postgres
useradd -m postgres -g postgres -d /home/postgres
passwd postgres
pass
pass


