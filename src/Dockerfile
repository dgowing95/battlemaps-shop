FROM wordpress:5.9.3
RUN echo "file_uploads = On\n" \
         "upload_max_filesize = 100M\n" \
         "post_max_size = 100M\n" \
         "max_execution_time = 60\n" \
         > /usr/local/etc/php/conf.d/uploads.ini