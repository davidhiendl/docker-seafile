# Dockerized Seafile Pro


## How to use
```
docker run \
	-ti \
	-v /docker-data/seafile:/data \
	-e SERVER_NAME=TESTSERVER \
	-e SERVER_IP=localhost.localdomain \
	-e SEAFILE_ADMIN_MAIL=test@example.com \
	-e SEAFILE_ADMIN_PASS=Temp12345 \
	-p 80:80 \
	dhswt/seafile:<tag>
```


## Environment Variables

| Variable               | Default   | Description                                                                                                                                                                                      |
| ---                    | ---       | ---                                                                                                                                                                                              |
| DATA_DIR               | /data     | Location where data is stored. Should reside on a volume. Default volume is also "/data".                                                                                                        |
| SETUP_MODE             | auto      | How Seafile should be configured on first run. "auto" will use environment to configure the server. "manual" will require the user to exec into the container and run the setup script manually. |
| DATABASE_TYPE          | sqlite    | Which database to use, supported options: "sqlite", "mysql". Note: MySQL requires additional MYSQL_* variables                                                                                   |
| **SERVER_NAME**        | none      | The name of the seafile server                                                                                                                                                                   |
| **SERVER_IP**          | none      | The address which user use to reach the seafile server                                                                                                                                           |
| ENABLE_CRON_GC         | 0         | If garbage collect cron should run, set to "1" to enable, requires MySQL as database                                                                                                             |
| CRON_GC_EXPR           | 0 3 * * * | NOTE: Currently fixed at default value. Cron expression for gc job, runs at 03:00 AM by default                                                                                                  |
| SEAFILE_UID            | 1000      | The UID of the seafile user                                                                                                                                                                      |
| SEAFILE_GID            | 1000      | The GID of the seafile user                                                                                                                                                                      |
| **SEAFILE_ADMIN_MAIL** | none      | The initial seafile admin e-mail address                                                                                                                                                         |
| **SEAFILE_ADMIN_PASS** | none      | The initial seafile admin password, password is not updated after initial setup                                                                                                                  |

__Bold variables are required__



## Setup with MySQL and Database Environment Variables
This container supports non-interactive setup via environment variables.
See <https://manual.seafile.com/deploy/using_mysql.html#setup-in-non-interactive-way> for reference.

| Variable              | Default  | Description                                                                                                                              |
| ---                   | ---      | ---                                                                                                                                      |
| DATABASE_TYPE         | sqlite   | Which database to use, supported options: "sqlite", "mysql". Note: MySQL requires additional MYSQL_* variables                           |
| **MYSQL_HOST**        | none     | MySQL database hostname to connect to                                                                                                    |
| MYSQL_PORT            | 3306     | MySQL database port                                                                                                                      |
| **MYSQL_ROOT_PASSWD** | none     | The name of the seafile server                                                                                                           |
| MYSQL_USER            | seafile  | The user to create for seafile                                                                                                           |
| **MYSQL_USER_PASSWD** | none     | MySQL password to user for the seafile user                                                                                              |
| MYSQL_USER_HOST       | %        | MySQL user host (access control) for the seafile user, defaults to any host                                                              |
| DB_PREFIX             | seafile_ | Database tables are prefixed with a unique identifier that groups them and allows multiple seafile installations with the same database. |
| CCNET_DB              | ccnet    | The database name to use for CCNET                                                                                                       |
| SEAFILE_DB            | seafile  | The database name to use for SEAFILE                                                                                                     |
| SEAHUB_DB             | seahub   | The database name to use for SEAHUB                                                                                                      |

#### Example run configuration for MySQL:

```
docker run \
	-ti \
	-v /docker-data/seafile:/data \
	-e SERVER_NAME=TESTSERVER \
	-e SERVER_IP=localhost.localdomain \
	-e SEAFILE_ADMIN_MAIL=test@example.com \
	-e SEAFILE_ADMIN_PASS=Temp12345 \
	-e DATABASE_TYPE=mysql \
	-e MYSQL_HOST=mysql.localdomain \
	-e MYSQL_ROOT_PASSWD=SomeRootPass \
	-e MYSQL_USER_PASSWD=SomeSeafileDbUserPass \
	-p 80:80 \
	dhswt/seafile:<tag>
```



## TODO
- configurable crontab for gc
- optional memcached (enable via env variable) for increased performance
- optional s3 storage backend
- support upgrading seafile automatically
- support automated backups with cron or on trigger
