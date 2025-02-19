FROM nginx:alpine
RUN sed -i -r '\
  /user\s+nginx;/d; \
  s@/var/run/nginx.pid@/tmp/nginx.pid@; \
  s@/var/log/nginx/error.log@stderr@; \
  s@/var/log/nginx/access.log@/dev/stdout@' \
  /etc/nginx/nginx.conf && \
  sed -i -r 's@listen\s+80;@listen 8080;@; s@/usr/share/nginx/html@/srv@' /etc/nginx/conf.d/default.conf && \
  sed -i '/server_name/a\    server_tokens off;' /etc/nginx/conf.d/default.conf && \
  sed -i -r 's@ index.htm;@;\n        try_files $uri $uri/ /index.html;@' /etc/nginx/conf.d/default.conf && \
  mv /usr/share/nginx/html/* /srv && \
  rmdir /usr/share/nginx/html /usr/share/nginx /var/cache/nginx && \
  ln -s /tmp /var/cache/nginx
USER 100
