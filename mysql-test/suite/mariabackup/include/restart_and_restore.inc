let $_datadir= `SELECT @@datadir`;
let $_undo_tablespaces= `SELECT @@innodb_undo_tablespaces`;
echo # shutdown server;
--source include/shutdown_mysqld.inc
echo # remove datadir;
rmdir $_datadir;
echo # xtrabackup move back;
exec $XTRABACKUP --defaults-file=$MYSQLTEST_VARDIR/my.cnf --innodb-undo-tablespaces=$_undo_tablespaces --copy-back --datadir=$_datadir --target-dir=$targetdir --parallel=2 --throttle=1;
echo # restart server;
--source include/start_mysqld.inc
