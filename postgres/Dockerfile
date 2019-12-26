FROM library/postgres:9.6

COPY 00-create-extensions.sql /docker-entrypoint-initdb.d/
COPY 01-create-tfm-db.sql /docker-entrypoint-initdb.d/