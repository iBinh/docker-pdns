import os
basedir = os.path.abspath(os.path.dirname(__file__))

### BASIC APP CONFIG
BIND_ADDRESS = '0.0.0.0'
PORT = 9191
HSTS_ENABLED = False

# CAPTCHA Config
CAPTCHA_ENABLE = True
CAPTCHA_LENGTH = 6
CAPTCHA_WIDTH = 160
CAPTCHA_HEIGHT = 60
CAPTCHA_SESSION_KEY = 'captcha_image'

SESSION_TYPE = 'sqlalchemy'

# SAML Authnetication
SAML_ENABLED = False

# Configuration from env vars
{%- for key, value in environment('PDNS_ADMIN_') %}
{%- set v = value | trim('"\'\\') %}
{%- if v in ['True', 'False', 'None', '0'] or v | int != 0 %}
{{ key }} = {{ v }}
{%- else %}
{{ key }} = '{{ v }}'
{%- endif %}
{%- endfor %}

### DATABASE CONFIG
SQLALCHEMY_DATABASE_URI = 'mysql://' + SQLA_DB_USER + ':' + SQLA_DB_PASSWORD + '@' + SQLA_DB_HOST + ':' + str(SQLA_DB_PORT) + '/' + SQLA_DB_NAME
SQLALCHEMY_TRACK_MODIFICATIONS = True
