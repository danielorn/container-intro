FROM php:7.2-apache        # Baseline on php image
COPY www/ /var/www/html/   # Copy custom html
COPY start.sh /start.sh    # Custom Startup script
RUN chmod +x /start.sh     # Make custom startup script executable
CMD ["/start.sh"]          # Set startup script