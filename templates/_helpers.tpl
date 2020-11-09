
{{- define "common-envs" -}}
          # apps
          - name: KOBO_SUPERUSER_USERNAME
            value: {{ .KOBO_SUPERUSER_USERNAME }}
          - name: KOBO_SUPERUSER_PASSWORD
            value: {{ .KOBO_SUPERUSER_PASSWORD }}
          - name: KOBO_SUPPORT_EMAIL
            value: {{ .KOBO_SUPPORT_EMAIL }}
          {{- if eq (.KOBOTOOLBOX_PROTOCOL | quote) "http" }}
          - name: HOST_ADDRESS
            value: {{ .PUBLIC_DOMAIN_NAME }}
          - name: KPI_PUBLIC_PORT
            value: 9000
          - name: KOBOCAT_PUBLIC_PORT
            value: 9001
          - name: ENKETO_EXPRESS_PUBLIC_PORT
            value: 9005
          {{- end }}
          {{- if eq (.KOBOTOOLBOX_PROTOCOL | quote) "https" }}
          - name: PUBLIC_DOMAIN_NAME
            value: {{ .PUBLIC_DOMAIN_NAME }}
          - name: KOBOFORM_PUBLIC_SUBDOMAIN
            value: {{ .KOBOFORM_PUBLIC_SUBDOMAIN }}
          - name: KOBOCAT_PUBLIC_SUBDOMAIN
            value: {{ .KOBOCAT_PUBLIC_SUBDOMAIN }}
          - name: ENKETO_EXPRESS_PUBLIC_SUBDOMAIN
            value: {{ .ENKETO_EXPRESS_PUBLIC_SUBDOMAIN }}
          {{- end }}
          {{- if eq .USE_ENV_VAR true }}
          - name: USE_ENV_VAR
            value: {{ .USE_ENV_VAR }}
          - name: KOBOFORM_URL
            value: {{ .KOBOTOOLBOX_PROTOCOL }}://{{ .KOBOFORM_SERVER_NAME }}
          - name: KOBOCAT_URL
            value: {{ .KOBOTOOLBOX_PROTOCOL }}://{{ .KOBOCAT_SERVER_NAME }}
          - name: ENKETO_URL
            value: {{ .KOBOTOOLBOX_PROTOCOL }}://{{ .ENKETO_SERVER_NAME }}
          - name: CSRF_COOKIE_DOMAIN
            value: {{ .CSRF_COOKIE_DOMAIN }}
          - name: DJANGO_ALLOWED_HOSTS
            value: {{ .DJANGO_ALLOWED_HOSTS }}
          - name: KOBOFORM_SERVER_NAME
            value: {{ .KOBOFORM_SERVER_NAME }}
          - name: KOBOCAT_SERVER_NAME
            value: {{ .KOBOCAT_SERVER_NAME }}
          - name: ENKETO_SERVER_NAME
            value: {{ .ENKETO_SERVER_NAME }}
          {{- end }}
          - name: TEMPLATE_DEBUG
            value: False
          # web server settings
          - name: KPI_WEB_SERVER
            value: {{ .PROXY_WEB_SERVER }}
          - name: KOBOCAT_WEB_SERVER
            value: {{ .PROXY_WEB_SERVER }}
          - name: KOBOCAT_STATIC_FILES_SERVER
            value: Nginx
          - name: KPI_STATIC_FILES_SERVER
            value: Nginx
          - name: ENKETO_PROTOCOL
            value: {{ .KOBOTOOLBOX_PROTOCOL }}
          - name: ENKETO_VERSION
            value: Express
          - name: ENKETO_API_TOKEN
            value: {{ .ENKETO_API_TOKEN }}
          - name: DJANGO_SECRET_KEY
            value: {{ .DJANGO_SECRET_KEY }}
          # email settings
          - name: EMAIL_BACKEND
            value: django.core.mail.backends.smtp.EmailBackend
          {{- if eq .USE_EXTERNAL_SMTP true }}
          - name: EMAIL_HOST
            value: {{ .EMAIL_HOST }}
          - name: EMAIL_PORT
            value: {{ .EMAIL_PORT }}
          - name: EMAIL_HOST_USER
            value: {{ .EMAIL_HOST_USER }}
          - name: EMAIL_HOST_PASSWORD
            value: {{ .EMAIL_HOST_PASSWORD }}
          - name: EMAIL_USE_TLS
            value: {{ .EMAIL_USE_TLS }}
          {{- end }}
          - name: DEFAULT_FROM_EMAIL
            value: {{ .KOBO_SUPPORT_EMAIL }}
          - name: CELERYD_TASK_TIME_LIMIT
            value: {{ .TASK_TIMEOUT }}
          - name: CELERYD_TASK_SOFT_TIME_LIMIT
            value: {{ .TASK_SOFT_TIMEOUT }}
{{- end }}

{{- define "specific-envs" -}}
  {{- if eq .name "kobocat" }}
          - name: POSTGRES_BACKUP_SCHEDULE
            value: {{ .POSTGRES_BACKUP_SCHEDULE }}
          - name: POSTGRES_BACKUP_ARCHIVE_FILENAME
            value: {{ .POSTGRES_BACKUP_ARCHIVE_FILENAME }}
          - name: MONGO_BACKUP_SCHEDULE
            value: {{ .MONGO_BACKUP_SCHEDULE }}
          - name: MONGO_BACKUP_ARCHIVE_FILENAME
            value: {{ .MONGO_BACKUP_ARCHIVE_FILENAME }}
          - name: KOBOCAT_MEDIA_BACKUP_SCHEDULE
            value: {{ .KOBOCAT_MEDIA_BACKUP_SCHEDULE }}
            {{- if eq .USE_CUSTOM_KOBOCAT true }}
          - name: DJANGO_SETTINGS_MODULE
            value: {{ .CUSTOM_KOBOCAT_DJANGO_SETTINGS_MODULE }}
          - name: CUSTOM_KOBOCAT_THEME_APP_PIP_URL
            value: {{ .CUSTOM_KOBOCAT_THEME_APP_PIP_URL }}
          - name: PYTHONPATH
            value: {{ .CUSTOM_KOBOCAT_PYTHONPATH }}
          - name: CUSTOM_KOBOCAT_THEME_DEPLOY_KEY
            value: {{ .CUSTOM_KOBOCAT_THEME_DEPLOY_KEY }}
            {{- else }}
          - name: DJANGO_SETTINGS_MODULE
            value: onadata.settings.kc_environ
            {{- end }}
          - name: KOBOCAT_DJANGO_DEBUG
            value: {{ .KOBOCAT_DJANGO_DEBUG }}
          - name: DATABASE_URL
            value: postgis://{{ .POSTGRES_USER }}:{{ .POSTGRES_PASSWORD }}@postgres:{{ .POSTGRES_PORT }}/{{ .POSTGRES_DBNAME }}
          - name: KOBO_POSTGRES_DB_NAME
            value: {{ .POSTGRES_DBNAME }}
          - name: KOBO_POSTGRES_USER
            value: {{ .POSTGRES_USER }}
          - name: KOBOCAT_BROKER_URL
            value: {{ .KOBOCAT_BROKER_URL }}
  {{- end }}
  {{- if eq .name "kpi" }}
          - name: KPI_DJANGO_DEBUG
            value: {{ .KPI_DJANGO_DEBUG }}
          - name: KPI_PREFIX
            value: {{ .KPI_PREFIX }}
          - name: KPI_BROKER_URL
            value: {{ .KPI_BROKER_URL }}
          - name: DATABASE_URL
            value: postgres://{{ .POSTGRES_USER }}:{{ .POSTGRES_PASSWORD }}@postgres:{{ .POSTGRES_PORT }}/{{ .POSTGRES_DBNAME }}
          - name: DJANGO_LANGUAGE_CODES
            value: {{ .DJANGO_LANGUAGE_CODES }}
            {{- if eq .KOBOTOOLBOX_PROTOCOL "https" }}
          - name: SECURE_PROXY_SSL_HEADER
            value: HTTP_X_FORWARDED_PROTO, {{ .KOBOTOOLBOX_PROTOCOL }}
            {{- end }}
  {{- end }}
  {{- if eq .name "nginx" }}
          - name: NGINX_CONFIG_FILE_NAME
            value: nginx_site_http.conf
          - name: TEMPLATED_VAR_REFS
            value: {{ .PUBLIC_DOMAIN_NAME }} {{ .KOBOFORM_PUBLIC_SUBDOMAIN }} {{ .KOBOCAT_PUBLIC_SUBDOMAIN }} {{ .ENKETO_EXPRESS_PUBLIC_SUBDOMAIN }}
  {{- end }}
  {{- if eq .name "db-backup" }}
          - name: ARCHIVE_FILENAME
            value: {{ .ARCHIVE_FILENAME }}
          - name: DUMPPREFIX
            value: {{ .DUMPPREFIX }}
          - name: PGHOST
            value: {{ .POSTGRES_HOST }}
          - name: PGPASSWORD
            value: {{ .POSTGRES_PASSWORD }}
          - name: PGPORT
            value: {{ .POSTGRES_PORT }}
          - name: PGUSER
            value: {{ .POSTGRES_USER }}
          - name: POSTGRES_DBNAME
            value: {{ .POSTGRES_DBNAME }}
          - name: POSTGRES_HOST
            value: {{ .POSTGRES_HOST }}
          - name: POSTGRES_PASSWORD
            value: {{ .POSTGRES_PASSWORD }}
          - name: POSTGRES_PORT
            value: {{ .POSTGRES_PORT }}
          - name: POSTGRES_USER
            value: {{ .POSTGRES_USER }}
          - name: WITH_POSTGIS
            value: "1"
  {{- end }}
  {{- if eq .name "mongo-btsync" }}
          - name: DEVICE
            value: ScanTerra Production - Mongo
          - name: SECRET
            value: ATCAWOQEHQJIGF6SLXUBL3BE6D2ZP3JF7
          - name: STANDBY_MODE
            value: "TRUE"
  {{- end }}
  {{- if eq .name "mongo" }}
          - name: MONGO_BACKUP_ARCHIVE_FILENAME
            value: {{ .MONGO_BACKUP_ARCHIVE_FILENAME }}
          - name: MONGO_BACKUP_SCHEDULE
            value: {{ .MONGO_BACKUP_SCHEDULE }}
          - name: MONGO_DATA
            value: {{ .MONGO_DATA }}
          - name: POSTGRES_BACKUP_ARCHIVE_FILENAME
            value: {{ .POSTGRES_BACKUP_ARCHIVE_FILENAME }}
          - name: POSTGRES_BACKUP_SCHEDULE
            value: {{ .POSTGRES_BACKUP_SCHEDULE }}
  {{- end }}
  {{- if eq .name "postgres" }}
          - name: ALLOW_IP_RANGE
            value: 0.0.0.0/0
          - name: POSTGRES_DBNAME
            value: {{ .POSTGRES_DBNAME }}
          - name: POSTGRES_PASSWORD
            value: {{ .POSTGRES_PASSWORD }}
          - name: POSTGRES_USER
            value: {{ .POSTGRES_USER }}
  {{- end }}
  {{- if eq .name "kobocat-btsync" }}
          - name: DEVICE
            value: ScanTerra Production - Kobocat
          - name: SECRET
            value: AW2VPXUMLCCPRRT6K53WEOUHT2HZCPVL3
          - name: STANDBY_MODE
            value: "TRUE"
  {{- end }}
  {{- if eq .name "kobo-postgres-btsync" }}
          - name: DEVICE
            value: ScanTerra Production - Kobo Postgres
          - name: SECRET
            value: APWDOMOXQCE74MVVJJFDWXD5YFMDS4VNC
          - name: STANDBY_MODE
            value: "TRUE"
  {{- end }}
  {{- if eq .name "rabbit" }}
          - name: RABBITMQ_LOG_BASE
            value: /var/log/rabbitmq
  {{- end }}
  {{- if eq .name "smtp" }}
          - name: maildomain
            value: {{ .PUBLIC_DOMAIN_NAME }}
          - name: smtp_user
            value: {{ .EMAIL_HOST_USER }}:{{ .EMAIL_HOST_PASSWORD }}
  {{- end }}
  {{- if eq .name "borg-backup-service" }}
          - name: ARCHIVE_PREFIX
            value: kobotoolbox
          - name: BACKUP_FROM
            value: /borg/data
          - name: BACKUP_WHAT
            value: .
          - name: BORG_PASSPHRASE
            value: {{ .BORG_PASSPHRASE }}
          - name: BORG_REPO
            value: /borg/repo
          - name: COMPRESSION
            value: lz4
          - name: KEEP_DAILY
            value: "7"
          - name: KEEP_MONTHLY
            value: "12"
          - name: KEEP_WEEKLY
            value: "4"
          - name: KEEP_YEARLY
            value: "1"
          - name: PRUNE
            value: "1"
  {{- end }}
  {{- if eq .name "borg-backup-service-server" }}
          - name: ARCHIVE_PREFIX
            value: kobotoolbox
          - name: BORG_PASSPHRASE
            value: {{ .BORG_PASSPHRASE }}
          - name: BORG_RELOCATED_REPO_ACCESS_IS_OK
            value: "yes"
          - name: BORG_REPO
            value: /borg/repo
          - name: USERS
            value: root
  {{- end }}
{{- end }}
