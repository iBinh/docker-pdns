FROM petrhung9/pdns-admin-base


RUN apt update && apt install -y nginx

EXPOSE 80

COPY pdns-nginx.conf /etc/nginx/nginx.conf

CMD [ "/usr/sbin/nginx", "-g", "daemon off;" ]