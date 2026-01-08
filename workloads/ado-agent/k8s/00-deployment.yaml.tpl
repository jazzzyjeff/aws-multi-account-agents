apiVersion: apps/v1
kind: Deployment
metadata:
  name: ado-deployment
  labels:
    app: adodj
spec:
  replicas: 1
  selector:
    matchLabels:
      app: adodj
  template:
    metadata:
      labels:
        app: adodj
    spec:
      containers:
      - name: adodj
        image: ${image}
        env:
          - name: AZP_URL
            value: ${azp_url}
          - name: AZP_POOL
            value: ${azp_pool}
          - name: AZP_TOKEN
            value: ${azp_token}
          - name: AZP_KIND
            value: deployment
        volumeMounts:
        - mountPath: /var/run/docker.sock
          name: docker-volume
      volumes:
      - name: docker-volume
        hostPath:
          path: /var/run/docker.sock