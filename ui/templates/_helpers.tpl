{{/*
Expand the name of the chart.
*/}}
{{- define "nodeui.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nodeui.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nodeui.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nodeui.labels" -}}
helm.sh/chart: {{ include "nodeui.chart" . }}
{{ include "nodeui.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nodeui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nodeui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{- define "service.name" -}}
{{ .Release.Name }}-service
{{- end -}}

{{- define "imagePullSecret" }}
{{- with .Values.imageCredentials }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{- define "imagepullsecret.fullname" }}
{{- if .Values.imageCredentials.registry }}
{{- .Release.Name }}-imagepullsecret
{{- end }}
{{- end }}

{{- define "pullsecrets" -}}
{{- if or (.Values.imagePullSecrets) (.Values.imageCredentials.registry) }}
imagePullSecrets:
  {{- if .Values.imagePullSecrets }}
  - name: {{ .Values.imagePullSecrets }}
  {{- else  }}
  - name: {{ include "imagepullsecret.fullname" . }}
  {{- end  }}
{{- end}}  
{{- end -}}


{{- define "healthcheck" -}}
{{- if eq .Values.healthcheck.enabled true -}}
livenessProbe:
  tcpSocket:
    port: {{ .Values.healthcheck.livenessProbe.port }}
  initialDelaySeconds: {{ .Values.healthcheck.livenessProbe.initialDelaySeconds }}
  periodSeconds: {{ .Values.healthcheck.livenessProbe.periodSeconds }} 
readinessProbe:
  tcpSocket:
    port: {{ .Values.healthcheck.readinessProbe.port }}
  initialDelaySeconds: {{ .Values.healthcheck.readinessProbe.initialDelaySeconds }}
  periodSeconds: {{ .Values.healthcheck.readinessProbe.periodSeconds }} 
{{- end -}}
{{- end -}}


{{- define "chart.resourceLimits" }}
resources:
  requests:
    memory: "{{ .Values.resources.requests.memory }}"
    cpu: "{{ .Values.resources.requests.cpu }}"
  limits:
    memory: "{{ .Values.resources.limits.memory }}"
    cpu: "{{ .Values.resources.limits.cpu }}"
{{- end }}