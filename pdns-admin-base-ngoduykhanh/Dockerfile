FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    python3 \
    python3-pip \
    uwsgi \
    uwsgi-plugin-python3 \
    libldap2-dev \
    libsasl2-dev \
    libxml2-dev \
    libmariadb-dev-compat \
    libmariadb-dev \
    libssl-dev \
    libffi-dev \
    pkg-config \
    libxml2-dev \
    libxmlsec1-dev \
    libxmlsec1-openssl \
    && rm -rf /var/lib/apt/lists/*

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs
RUN npm install -g yarn

RUN mkdir -p /opt/powerdns-admin \
    && curl -sSL https://github.com/iBinh/PowerDNS-Admin/archive/refs/tags/v0.4.1.5.tar.gz \
    | tar -xzC /opt/powerdns-admin --strip 1 \
    && sed -i '/lxml/d' /opt/powerdns-admin/requirements.txt \
    && sed -i '/mysqlclient/d' /opt/powerdns-admin/requirements.txt \
    && sed -i '/psycopg2/d' /opt/powerdns-admin/requirements.txt

WORKDIR /opt/powerdns-admin

RUN pip3 install wheel setuptools pip --upgrade
RUN pip3 install --no-cache-dir envtpl python-dotenv \
    && pip3 install -r requirements.txt --no-cache-dir --ignore-installed

ENV FLASK_APP=/opt/powerdns-admin/powerdnsadmin/__init__.py

COPY config.py.tpl /
COPY run.py .

RUN envtpl < /config.py.tpl > /opt/powerdns-admin/config.py \
    && sed -i '/SQLALCHEMY_DATABASE_URI/d' /opt/powerdns-admin/config.py

RUN yarn install --pure-lockfile --production \
    && yarn cache clean \
    && flask assets build

RUN useradd -r -M -d /opt/powerdns-admin -s /usr/sbin/nologin uwsgi

RUN chown -R uwsgi: /opt/powerdns-admin/powerdnsadmin/static/.webassets-cache
