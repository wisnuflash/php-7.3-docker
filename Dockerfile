FROM ubuntu:latest

# Install software-properties-common to add PPAs
RUN apt-get update && apt-get install -y \
    software-properties-common nano \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update

# Install Apache and PHP 7.3 from the PPA
RUN apt-get install -y \
    apache2 \
    php7.3 \
    php7.3-cli \
    php7.3-mysql \
    php7.3-xml \
    php7.3-gd \
    php7.3-curl \
    php7.3-mbstring \
    php7.3-zip \
    wget \
    unzip \
    curl \
    && apt-get clean

# Enable Apache modules
RUN a2enmod rewrite
RUN a2enmod headers

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install ionCube Loader
RUN wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xzf ioncube_loaders_lin_x86-64.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.3.so /usr/lib/php/20180731/ \
    && echo "zend_extension=/usr/lib/php/20180731/ioncube_loader_lin_7.3.so" > /etc/php/7.3/apache2/conf.d/00-ioncube.ini \
    && echo "zend_extension=/usr/lib/php/20180731/ioncube_loader_lin_7.3.so" > /etc/php/7.3/cli/conf.d/00-ioncube.ini \
    && rm -rf ioncube*


# Copy the custom apache2.conf
COPY apache2.conf /etc/apache2/apache2.conf

# Set up Apache's DocumentRoot
RUN rm -rf /var/www/html && mkdir -p /var/www/html
WORKDIR /var/www/html

# Expose port 80 for Apache
EXPOSE 80

# Start Apache in foreground
CMD ["apachectl", "-D", "FOREGROUND"]
