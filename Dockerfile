FROM debian:buster

RUN	apt-get update && apt-get install \
	wget nginx php-fpm php-mysql php-xml mariadb-server -y

WORKDIR /tmp
RUN wget https://wordpress.org/latest.tar.gz \
	&& tar xf latest.tar.gz && mv wordpress/ /var/www/html/
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-english.tar.gz \
	&& tar xf phpMyAdmin-5.1.0-english.tar.gz \
	&& mv phpMyAdmin-5.1.0-english /var/www/html/wordpress/phpmyadmin


WORKDIR /var/www/html/wordpress
RUN sed -i "s/database_name_here/wordpress/g" wp-config-sample.php \
	&& sed -i "s/username_here/user/g" wp-config-sample.php \
	&& sed -i "s/password_here/user/g" wp-config-sample.php \
	&& chown -R www-data /var/www/html/wordpress \
	&& chmod -R 755 /var/www/html/wordpress

COPY srcs/nginx.conf /etc/nginx/sites-available/
RUN rm -f /etc/nginx/sites-available/default && \
	rm -f /etc/nginx/sites-enabled/default && \
	ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

WORKDIR /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 \
	-days 356 -nodes -out my-cert.crt -keyout \
	my-cert.key -subj "/C=RU/ST=KRD/L=KZN/O=OOO/OU=ROGA and KoPITA/CN=localhost"

WORKDIR /usr/local
COPY srcs/wordpress.sql .
COPY srcs/script.sh .
RUN chown root script.sh && chmod 755 script.sh

CMD ["bash", "script.sh"]
