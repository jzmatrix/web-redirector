FROM debian:11
################################################################################
RUN apt -y update && \
    apt -y upgrade && \
    apt -y install apache2
################################################################################
RUN /bin/rm -f /etc/localtime && \
    /bin/cp /usr/share/zoneinfo/America/New_York /etc/localtime
################################################################################
ADD config/script/configApacheRedirects /opt/configApacheRedirects
ADD config/apache2/apache2.conf /etc/apache2/apache2.conf
ADD config/apache2/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD config/apache2/info.conf /etc/apache2/mods-available/info.conf
ADD config/apache2/status.conf /etc/apache2/mods-available/status.conf
RUN chmod 644 /etc/apache2/apache2.conf && \
    chmod 644 /etc/apache2/sites-available/000-default.conf && \
    chmod 644 /etc/apache2/mods-available/info.conf && \
    chmod 644 /etc/apache2/mods-available/status.conf && \
    ln -f -s /etc/apache2/mods-available/info.conf /etc/apache2/mods-enabled/ ; \
    ln -f -s /etc/apache2/mods-available/info.load /etc/apache2/mods-enabled/ ; \
    ln -f -s /etc/apache2/mods-available/remoteip.load /etc/apache2/mods-enabled/ ; \
    ln -f -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/  ; \
    ln -f -s /etc/apache2/mods-available/status.conf /etc/apache2/mods-enabled/ ; \
    ln -f -s /etc/apache2/mods-available/status.load /etc/apache2/mods-enabled/ 
################################################################################
# Clear out default folder and replace
RUN rm -rf /var/www/html
ADD www /var/www/html
################################################################################
# Simple startup script to avoid some issues observed with container restart
ADD config/run-httpd.sh /run-httpd.sh
ADD config/startServices.sh /opt/startServices.sh
RUN chmod -v +x /run-httpd.sh && \
    chmod 755 /opt/startServices.sh && \
    chmod 755 /opt/configApacheRedirects
################################################################################
CMD [ "/opt/startServices.sh" ]
