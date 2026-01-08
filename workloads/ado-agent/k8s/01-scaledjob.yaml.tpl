apiVersion: keda.sh/v1alpha1
kind: ScaledJob
metadata:
  name: ado-scaledjob
  labels:
    name: adosj
spec:
  jobTargetRef:
    template:
      metadata:
        labels:
          name: adosj
      spec:
        containers:
        - name: adosj
          image: ${image}
          env:
          - name: AZP_URL
            value: ${azp_url}
          - name: AZP_POOL
            value: ${azp_pool}
          - name: AZP_TOKEN
            value: ${azp_token}
          volumeMounts:
          - mountPath: /var/run/docker.sock
            name: dockervolume
        volumes:
        - name: dockervolume
          hostPath:
            path: /var/run/docker.sock
  pollingInterval: 10
  successfulJobsHistoryLimit: 0
  failedJobsHistoryLimit: 0
  maxReplicaCount: 10
  scalingStrategy:
    strategy: "default"
  triggers:
  - type: azure-pipelines
    metadata:
      poolName: ${azp_pool}
      organizationURLFromEnv: "AZP_URL"
      personalAccessTokenFromEnv: "AZP_TOKEN"