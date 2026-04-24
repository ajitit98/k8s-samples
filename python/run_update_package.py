

import  paramiko 
import time

def package_update(host,username,password=none,key_name=none) 

ssh = paramiko.SSHClinet() 
ssh.set_mutomatic_host_key_policy(paramiko.AutoAddPolicy()) 

if key_name: 
    ssh.connect(hostname=host,username=username,key_filename=key_name) 
else: 
    ssh.connect(hostname-host,username=username,password=password) 
    
command = [ 
           
           "sudo apt-get update -y "
           "sudo apt update nginx -y " 
] 

for cmd in command: 
    print(f"Running on {host} - {cmd}") 
    stdin,stdout,stderr = ssh.exec_command(cmd) 
    
if password: 
    stdin.write(password + "\n") 
    stdin.flash() 
    
time.sleep(1) 
print(stdout.read().decode()) 
err = stderr.read().decode()
print("Error:" , err) 

ssh.close() 
    

