
def server_config_update(file_name,key,value) 

with open('file_name','r') as file: 
    line = file.readlines() 
    
with open('file_name','w') as file: 
    for line in lines: 
        if key in line: 
            file.write(key + "=" + value + "\n") 
        else: 
           file.read(line) 
    
