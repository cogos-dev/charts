{{/*
Full name for the mod3 release.
*/}}
{{- define "cogos-mod3.fullname" -}}
{{- if contains "cogos-mod3" .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-cogos-mod3" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
