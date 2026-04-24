
from kubernetes import client , config 
client.load_kube_config() 
v1 = client.CoreV1Api() 


pods = v1.list_pod_from_all_namespaces() 
for pod in pods.items: 
    print(f"{pod.metadata.namespaces} - {pod.metadata.name}") 
          