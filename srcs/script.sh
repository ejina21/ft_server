service mysql start

mariadb --user="root" --password="user" --execute="CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mariadb --user="root" --password="user" --execute="GRANT ALL ON wordpress.* TO 'user'@'localhost' IDENTIFIED BY 'user';"
mariadb --user="root" --password="user" --execute="FLUSH PRIVILEGES;"
mariadb -u root --password="user" wordpress < wordpress.sql
service php7.3-fpm start
service nginx start

while true; do
	sleep 30
done
