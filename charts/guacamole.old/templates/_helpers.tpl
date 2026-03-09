{{- define "guacamole.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "guacamole.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "guacamole.name" . -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "guacamole.labels" -}}
app.kubernetes.io/name: {{ include "guacamole.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{- end -}}

{{- define "guacamole.selectorLabels" -}}
app.kubernetes.io/name: {{ include "guacamole.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "guacamole.validate" -}}
{{- if .Values.externalSecrets.enabled -}}
{{- if not .Values.externalSecrets.store.name -}}
{{- fail "externalSecrets.enabled=true pero externalSecrets.store.name está vacío" -}}
{{- end -}}
{{- if not .Values.externalSecrets.remoteKey -}}
{{- fail "externalSecrets.enabled=true pero externalSecrets.remoteKey está vacío" -}}
{{- end -}}
{{- end -}}

{{- if not .Values.externalPostgres.existingSecret.name -}}
{{- fail "externalPostgres.existingSecret.name está vacío" -}}
{{- end -}}
{{- if not .Values.externalPostgres.existingSecret.key -}}
{{- fail "externalPostgres.existingSecret.key está vacío" -}}
{{- end -}}
{{- end -}}