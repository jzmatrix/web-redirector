#!/bin/bash

# Read the redirect configmap and build an .htaccess to handle redirects
/opt/configApacheRedirects

# Setup and start the HTTP daemon
/run-httpd.sh
