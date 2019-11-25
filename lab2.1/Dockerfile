FROM php:7.2-apache
COPY www/ /var/www/html/
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]