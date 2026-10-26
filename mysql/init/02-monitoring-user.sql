-- Replace the placeholder below with the same value as MYSQL_EXPORTER_PASSWORD in .env before first start.
CREATE USER IF NOT EXISTS 'exporter'@'%' IDENTIFIED BY 'CHANGE_ME_exporter_password_24_chars_minimum';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
FLUSH PRIVILEGES;
