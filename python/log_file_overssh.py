
import paramiko

ssh = paramiko.SSHClinet() 
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy()) 

def log_checking(host, username, password=none,key_file=none) 

if key_file in none: 
    ssh.connect(hostname=host,username=username,key_file=key_file) 
else: 
    ssh.connecct(hostname=host,username=username,password=password) 
    
command = [
    "tail -f /var/log/messages" 
]

for cmd in commands : 
    print(f"Collect log file: {host} - {cmd}") 
    stdin,stdout,srderr = ssh.exec_command(cmd) 
    
    
if password: 
    stdin.write(password + "\n") 
    stdin.flash() 
    
 std_out = stdout.read().decode() 
 std_err = stderr.read().decode() 
 
 if std_out: 
     print(std_out) 
     
 if std_err: 
     print(std_err) 
    