import paramiko

def check_logs(host, username, password=None, key_file=None, log_commands=None):
    """
    Connects to a remote server and runs log-checking commands over SSH.

    :param host: remote host IP/domain
    :param username: SSH user
    :param password: SSH password
    :param key_file: optional SSH key file path
    :param log_commands: list of log commands to run
    """
    # Default log commands if not provided
    if log_commands is None:
        log_commands = [
            "sudo tail -n 50 /var/log/syslog",           # Last 50 lines of syslog
            "sudo tail -n 50 /var/log/auth.log",         # Last 50 lines of auth log
            "sudo journalctl -u nginx --no-pager --since '1 hour ago'",  # Recent nginx logs
            "sudo dmesg | tail -n 50"                    # Kernel log tail
        ]

    # Create SSH client
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    # Connect
    if key_file:
        ssh.connect(hostname=host, username=username, key_filename=key_file)
    else:
        ssh.connect(hostname=host, username=username, password=password)

    # Loop through log commands, execute, collect output
    for cmd in log_commands:
        print(f"\n📌 Running: {cmd}\n{'-'*40}")
        stdin, stdout, stderr = ssh.exec_command(cmd)

        # If your server prompts for sudo and needs a password:
        if password:
            stdin.write(password + "\n")
            stdin.flush()

        # Read output and errors
        out_str = stdout.read().decode()
        err_str = stderr.read().decode()

        if out_str:
            print(out_str)
        if err_str:
            print("❗ Errors:", err_str)

    # Close connection
    ssh.close()





















