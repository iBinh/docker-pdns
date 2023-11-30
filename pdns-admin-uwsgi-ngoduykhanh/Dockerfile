FROM petrhung9/pdns-admin-base

RUN apt update && apt install -y mariadb-server uwsgi-plugin-python3
EXPOSE 9494

COPY docker-entrypoint.sh /
COPY pdns-admin.ini /etc/uwsgi.ini
RUN chown uwsgi: /etc/uwsgi.ini

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "uwsgi", "--ini", "/etc/uwsgi.ini" ]