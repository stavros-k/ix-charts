{{/* The pod definition included in the controller. */}}
{{- define "ix.v1.common.controller.pod" -}}
{{- $root := . }}
{{- $values := fromYaml (tpl ($.Values | toYaml) $) }}
serviceAccountName: {{ (include "ix.v1.common.names.serviceAccountName" $root) }}
{{- $hostNet := false -}}
{{- if hasKey $values.controllers.main.pod "hostNetwork" -}}
  {{- $hostNet = $values.controllers.main.pod.hostNetwork -}}
{{- else -}}
  {{- $hostNet = $root.Values.hostNetwork -}}
{{- end }}
hostNetwork: {{ $hostNet }}
enableServiceLinks: {{ $values.controllers.main.pod.enableServiceLinks }}
{{- with (include "ix.v1.common.restartPolicy" (dict "restartPolicy" $values.controllers.main.pod.restartPolicy "root" $root) | trim) }}
restartPolicy: {{ . }}
{{- end -}}

{{- with $values.controllers.main.pod.schedulerName }}
schedulerName: {{ . }}
{{- end -}}

{{- with $values.controllers.main.pod.priorityClassName }}
priorityClassName: {{ . }}
{{- end }}

{{- with $values.controllers.main.pod.hostname }}
hostname: {{ . }}
{{- end -}}

{{- $dnsPol := (include "ix.v1.common.dnsPolicy" (dict "dnsPolicy" $values.controllers.main.pod.dnsPolicy "hostNetwork" $hostNet "root" $root) | trim ) -}}
{{- with (include "ix.v1.common.dnsPolicy" (dict "dnsPolicy" $values.controllers.main.pod.dnsPolicy "hostNetwork" $hostNet "root" $root) | trim ) }}
dnsPolicy: {{ . }}
{{- end -}}

{{- $dnsConf := ($values.controllers.main.pod.dnsConfig | default $root.Values.dnsConfig) -}}
{{- with (include "ix.v1.common.dnsConfig" (dict "dnsPolicy" $dnsPol "dnsConfig" $dnsConf "root" $root) | trim ) }}
dnsConfig:
  {{- . | nindent 2 }}
{{- end -}}

{{- with (include "ix.v1.common.hostAliases" (dict "hostAliases" $values.controllers.main.pod.hostAliases "root" $root) | trim) }}
hostAliases:
  {{- . | nindent 2 }}
{{- end -}}

{{- with (include "ix.v1.common.nodeSelector" (dict "nodeSelector" $values.controllers.main.pod.nodeSelector "root" $root) | trim) }}
nodeSelector:
  {{- . | nindent 2 }}
{{- end -}}

{{- with (include "ix.v1.common.tolerations" (dict "tolerations" $values.controllers.main.pod.tolerations "root" $root) | trim) }}
tolerations:
  {{- . | nindent 2 }}
{{- end -}}

{{- with (include "ix.v1.common.imagePullSecrets" (dict "imagePullCredentials" $values.imagePullCredentials "root" $root) | trim) }}
imagePullSecrets:
  {{- . | nindent 2 }}
{{- end -}}

{{- with (include "ix.v1.common.runtimeClassName" (dict "root" $root "runtime" $values.controllers.main.pod.runtimeClassName) | trim) }}
runtimeClassName: {{ . }}
{{- end -}}

{{/* TODO: affinity, topologySpreadConstraints, not something critical as of now. */}}
{{- with $values.controllers.main.pod.terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ . }}
{{- end -}}

{{- with (include "ix.v1.common.container.podSecurityContext" (dict "podSecCont" $values.controllers.main.pod.securityContext "root" $root) | trim) }}
securityContext:
  {{- . | nindent 2 }}
{{- end -}}

{{- with (include "ix.v1.common.controller.mainContainer" (dict "values" $values.controllers.main.pod.containers.main "root" $root) | trim) }}
containers:
  {{- . | nindent 2 }}
  {{- with (include "ix.v1.common.controller.extraContainers" (dict "root" $root "containerList" $values.additionalContainers "type" "additional") | trim) }}
    {{- . | nindent 2 }}
  {{- end -}}
{{- end -}}

{{- $installContainers := (include "ix.v1.common.controller.extraContainers" (dict "root" $root "containerList" $values.installContainers "type" "install") | trim) -}}
{{- $upgradeContainers := (include "ix.v1.common.controller.extraContainers" (dict "root" $root "containerList" $values.upgradeContainers "type" "upgrade") | trim) -}}
{{- $systemContainers := (include "ix.v1.common.controller.extraContainers" (dict "root" $root "containerList" $values.systemContainers "type" "system") | trim) -}}
{{- $initContainers := (include "ix.v1.common.controller.extraContainers" (dict "root" $root "containerList" $values.initContainers "type" "init") | trim) -}}

{{- if or $initContainers $systemContainers $installContainers $upgradeContainers }}
initContainers:
  {{- with $installContainers -}}
    {{- . | nindent 2 }}
  {{- end -}}

  {{- with $upgradeContainers -}}
    {{- . | nindent 2 }}
  {{- end -}}

  {{- with $systemContainers -}}
    {{- . | nindent 2 }}
  {{- end -}}

  {{- with $initContainers -}}
    {{- . | nindent 2 }}
  {{- end -}}
{{- end -}}

{{- with (include "ix.v1.common.controller.volumes" (dict "persistence" $root.Values.persistence "root" $root) | trim) }}
volumes:
    {{- . | nindent 2 }}
{{- end -}}

{{- end -}}
