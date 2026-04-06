{{/*
Full name for the kernel release.
*/}}
{{- define "cogos-kernel.fullname" -}}
{{- if contains "cogos-kernel" .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-cogos-kernel" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
