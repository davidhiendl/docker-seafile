# Seafile Pro Server


## Environment Variables
`*Bold variables are required*`
| Variable | Default | Description |
| --- | --- | --- |
| DATA_DIR | "/data" | Location where data is stored. Should reside on a volume. Default volume is also "/data". |
| SETUP_MODE | "auto" | How Seafile should be configured on first run. "auto" will use environment to configure the server. "manual" will require the user to exec into the container and run the setup script manually. |
| DB_PREFIX | "seafile_" | Database tables are prefixed with a unique identifier that groups them and allows multiple seafile installations with the same database. |
| *SERVER_NAME* | none | *Required* The name of the seafile server |
| *SERVER_IP* | none | *Required* The address which user use to reach the seafile server |
| ENABLE_CRON_GC | "0" | If garbage collect cron should run, set to "1" to enable |
| CRON_GC_EXPR | "0 1 * * *" | Cron expression for gc job, runs at 01:00 AM by default"
| SEAFILE_UID | "1000" | The UID of the seafile user |
| SEAFILE_GID | "1000" | The GID of the seafile user |
| *SEAFILE_ADMIN_MAIL* | none | The initial seafile admin e-mail address |
| *SEAFILE_ADMIN_PASS* | none | The initial seafile admin password, password is not updated after initial setup |


## TODO
- gc cron job (if configured to use mysql, not supported for sqlite
- configurable crontab for gc
- optional memcached (enable via env variable) for increased performance
- optional s3 storage backend