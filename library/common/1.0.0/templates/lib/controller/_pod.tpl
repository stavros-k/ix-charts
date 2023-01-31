{{/* Pod Spec */}}
{{/* Call this template:
{{ include "ix.v1.common.lib.controller.pod" (dict "rootCtx" $ "objectData" $objectData) }}
rootCtx: The root context of the template. It is used to access the global context.
objectData: The object data to be used to render the Pod.
*/}}
{{- define "ix.v1.common.lib.controller.pod" -}}
  {{- $rootCtx := .rootCtx -}}
  {{- $objectData := .objectData -}}
#TODO:serviceAccountName:
  {{- with (include "ix.v1.common.lib.pod.imagePullSecrets" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
imagePullSecrets:
    {{-  . | nindent 2 }}
  {{- end }}
hostNetwork: {{ include "ix.v1.common.lib.pod.hostNetwork" (dict "rootCtx" $rootCtx "objectData" $objectData) }}
enableServiceLinks: {{ include "ix.v1.common.lib.pod.enableServiceLinks" (dict "rootCtx" $rootCtx "objectData" $objectData) }}
restartPolicy: {{ include "ix.v1.common.lib.pod.restartPolicy" (dict "rootCtx" $rootCtx "objectData" $objectData) }}
  {{- with (include "ix.v1.common.lib.pod.schedulerName" (dict "rootCtx" $rootCtx "objectData" $objectData)) }}
schedulerName: {{ . }}
  {{- end -}}
  {{- with (include "ix.v1.common.lib.pod.priorityClassName" (dict "rootCtx" $rootCtx "objectData" $objectData)) }}
priorityClassName: {{ . }}
  {{- end }}
  {{- with (include "ix.v1.common.lib.pod.nodeSelector" (dict "rootCtx" $rootCtx "objectData" $objectData) | trim) }}
nodeSelector:
    {{- . | nindent 2 }}
  {{- end -}}
  {{- with (include "ix.v1.common.lib.pod.hostname" (dict "rootCtx" $rootCtx "objectData" $objectData)) }}
hostname: {{ . }}
  {{- end }}
  {{- with (include "ix.v1.common.lib.pod.terminationGracePeriodSeconds" (dict "rootCtx" $rootCtx "objectData" $objectData)) }}
terminationGracePeriodSeconds: {{ . }}
  {{- end }}
{{- end -}}
