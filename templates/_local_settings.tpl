{{- define "local_settings" }}
# -*- mode: python -*-
"""
Django settings for langstroth project.

Generated by 'django-admin startproject' using Django 1.11.11.

For more information on this file, see
https://docs.djangoproject.com/en/1.11/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.11/ref/settings/
"""

import os

TEST_MODE = False
{{- if .Values.conf.debug }}
DEBUG = True
LOG_LEVEL = 'DEBUG'
{{- else }}
LOG_LEVEL = 'INFO'
{{- end }}

ADMINS = (
)

SERVER_EMAIL = 'root@status.rc.nectar.org.au'
MANAGERS = ADMINS

ALLOWED_HOSTS = [
{{- range .Values.conf.allowed_hosts }}
  '{{ . }}',
{{- end }}
]

SECRET_KEY = os.getenv("DJANGO_SECRET_KEY", "{{ .Values.conf.secret_key }}")

# Database
# https://docs.djangoproject.com/en/1.11/ref/settings/#databases

DB_PASSWORD = os.getenv("DJANGO_DB_PASSWORD", "{{ .Values.conf.db_password }}")

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': '{{ .Values.conf.db_name }}',
        'HOST': '{{ .Values.conf.db_host }}',
        'USER': '{{ .Values.conf.db_user }}',
        'PASSWORD': DB_PASSWORD,
        'PORT': '',
    },
}
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': [
                     {{- range .Values.conf.memcached_hosts }}
                     '{{ . }}',
                     {{- end }}
                     ]
    },
}

# The URL to your Nagios installation.
NAGIOS_URL = "{{ .Values.conf.nagios_url }}"

# The user and password to authenticate to Nagios as.
NAGIOS_AUTH = ("{{ .Values.conf.nagios_username }}", "{{ .Values.conf.nagios_password }}")

# The service group to use for calculating if services are up and
# their availability.
NAGIOS_SERVICE_GROUP = '{{ .Values.conf.nagios_servicegroup }}'

# The URL to the graphite web interface
GRAPHITE_URL = "{{ .Values.conf.graphite_url }}"

# URL of allocation api
ALLOCATION_API_URL = "{{ .Values.conf.allocation_api_url }}"

STATIC_URL = '{{ .Values.conf.static_url }}'

{{- if .Values.conf.swift.auth_url }}

STATICFILES_STORAGE = 'swift.storage.StaticSwiftStorage'
SWIFT_AUTH_URL = '{{ .Values.conf.swift.auth_url }}'
SWIFT_AUTH_VERSION = '3'
SWIFT_USERNAME = '{{ .Values.conf.swift.username }}'
SWIFT_KEY = os.getenv("DJANGO_SWIFT_KEY", "{{ .Values.conf.swift.key }}")
SWIFT_TENANT_NAME = '{{ .Values.conf.swift.tenant_name }}'
SWIFT_USER_DOMAIN_NAME = '{{ .Values.conf.swift.user_domain_name }}'
SWIFT_PROJECT_DOMAIN_NAME = '{{ .Values.conf.swift.project_domain_name }}'
SWIFT_STATIC_CONTAINER_NAME = '{{ .Values.conf.swift.static_container_name }}'
{{- end }}


# A sample logging configuration. The only tangible logging
# performed by this configuration is to send an email to
# the site admins on every HTTP 500 error when DEBUG=False.
# See http://docs.djangoproject.com/en/dev/topics/logging for
# more details on how to customize your logging configuration.
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'simple': {
            'format': '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'simple',
        },
    },
    'loggers': {
        '': {
            'handlers': ['console',],
            'level': LOG_LEVEL,
        },
    }
}

CORES_TARGETS = [
{{- range .Values.conf.cores_targets }}
  {{ . }},
{{- end }}
]

INST_TARGETS = [
{{- range .Values.conf.inst_targets }}
  {{ . }},
{{- end }}
]

COMPOSITION_QUERY = {{ toJson .Values.conf.composition_query }}

{{- end }}
