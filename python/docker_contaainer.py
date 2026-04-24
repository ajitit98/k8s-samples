
import container 
client = docker.from_env 

def starting_container(image_name,container_name.command=none) 

print(f"pulling image {image_name}") 
client.pull(image_name) 

print(f"starting container from image {image_name}") 
container = client.container.run(
   image_name, 
   name=container_name, 
   command=command, 
   detach=True) 

print(f"container run with id : {container.id}") 
return container 

starting_container("nginx",container_name="nginx_contsiner") 
                                 
                                 
