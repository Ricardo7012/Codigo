[[_TOC_]]

https://learn.microsoft.com/en-us/azure/devops/project/wiki/markdown-guidance?view=azure-devops

# LOGS
``` bash
sudo tail -n 100 -f /run/media/mdbadmin/Data/mongodb/log/mongod.log
sudo tail -n 100 -f /var/log/messages
## OR JUST CURRENT DAY
sudo grep "$(date +'%b %e')" /var/log/messages
```

# Firewall

```bash
sudo iptables -A OUTPUT -p tcp --dport 15692 -j ACCEPT

sudo firewall-cmd --add-port=9090/tcp --permanent
sudo firewall-cmd --add-port=15672/tcp --permanent
sudo firewall-cmd --add-port=5672/tcp --permanent
sudo firewall-cmd --add-port=15692/tcp --permanent
sudo firewall-cmd --reload

sudo firewall-cmd --zone=public --add-port=15692/tcp --permanent

sudo systemctl restart firewalld

sudo firewall-cmd --zone=public --list-ports
15692/tcp

sudo firewall-cmd --list-port
4369/tcp 5672/tcp 6000-6500/tcp 15672/tcp 15692/tcp 25672/tcp 35672-35682/tcp 161/udp

#LIST EVERY PROCESS RELATED TO FIREWALL
ps -ef | grep firewall
root       18021       1  0 Jan17 ?        00:00:01 /usr/libexec/platform-python -s /usr/sbin/firewalld --nofork --nopid
i4682     609173  601696  0 10:48 pts/0    00:00:00 grep --color=auto firewall

#sudo netstat -anp
#sudo netstat -a | more
```

# RABBITMQ
```bash
sudo vi /etc/rabbitmq/advanced.config

sudo vi /etc/rabbitmq/rabbitmq.conf

sudo tail /var/log/rabbitmq/rabbit@dvrabbmq01.log -f

sudo grep "$(date +'%b %e')" /var/log/messages

sudo service rabbitmq-server restart

sudo service rabbitmq-server status

sudo rabbitmq-diagnostics -q cluster_status

sudo firewall-cmd --zone=public --add-port=5671/tcp --permanent

sudo rabbitmq-diagnostics -s listeners

sudo firewall-cmd --list-port

sudo service rabbitmq-server status

rabbitmq-diagnostics check_running

rabbitmqctl list_channels pid name global_prefetch_count | sed -n '/t0$/!p'

rabbitmqctl -p vhost-1 disable_classic_mirroring

rabbitmqctl -p vhost-1 enable_classic_mirroring

rabbitmqctl set_policy --apply-to queues classic_queue_mirroring '{"ha-mode":"all"}'

rabbitmq-plugins disable rabbitmq_classic_queue_mirroring

rabbitmqctl set_policy --apply-to queues classic_mirrored_queue_version "^<queue-name>$" '{"ha-mode":"exactly","ha-params":1}'

service rabbitmq-server restart

rabbitmqctl set_policy --apply-to queues classic_mirrored_queue_version "^<queue-name>$" '{"ha-mode":"exactly","ha-params":1}'
Setting policy "classic_mirrored_queue_version" for pattern "^<queue-name>$" to "{"ha-mode":"exactly","ha-params":1}" with priority "0" for vhost "/" ...

rabbitmqctl clear_policy --apply-to queues classic_mirrored_queue_version

rabbitmqctl set_policy --apply-to queues classic_mirrored_queue_version "^<queue-name>$" '{"ha-mode":"all"}'

sudo tail /var/log/rabbitmq/rabbit@pvrabbmq01.log -f
sudo tail /var/log/rabbitmq/rabbit@pvrabbmq02.log -f
sudo tail /var/log/rabbitmq/rabbit@pvrabbmq03.log -f

deprecated_features.permit.classic_queue_mirroring = true
```
# Systemd Cheat Sheet
https://dev.azure.com/IEHPProducts/Architecture-Development%20Sandbox/_wiki/wikis/Architecture-Development-Sandbox.wiki/1290/Systemd-Cheat-Sheet

# User Management
https://dev.azure.com/IEHPProducts/Architecture-Development%20Sandbox/_wiki/wikis/Architecture-Development-Sandbox.wiki/1300/User-Management


# MongoDB Post update quick checks
https://dev.azure.com/IEHPProducts/Architecture-Development%20Sandbox/_wiki/wikis/Architecture-Development-Sandbox.wiki/4602/Post-update-quick-checks
--https://www.mongodb.com/docs/manual/reference/command/getLog/

```bash
cls;
use admin;
//LOOK FOR ok: 1,
// https://www.mongodb.com/basics/how-to-monitor-mongodb-and-what-metrics-to-monitor
// https://ittutorial.org/mongodb-healthcheck-step-by-step/
db.runCommand("ping").ok;
db.stats().ok;
rs.status().ok;
db.serverStatus().ok;
db.runCommand({dbStats: 1}).ok;
db.runCommand({top: 1 }).ok;
db.adminCommand({ getLog: "*" }).ok;
db.runCommand({ connectionStatus: 1, showPrivileges: true }).ok;
//db.adminCommand({ getLog:'global'})
//db.adminCommand({ getLog:'global'}).log.forEach(x => {print(x)})
//db.adminCommand({ getLog:'global' }).log.filter(entry => entry.includes('NETWORK')).forEach(entry => print(entry));
db.getSiblingDB("admin").runCommand({getCmdLineOpts: 1});
# tail -n 100 -f /mnt/provision/newsource/vdb_mount/logs/dlpx.s0m0.28510.mongod.log

// Get the replica set status
// YOU WANT RESULTS TO BE 1,2 OR 7
// https://www.mongodb.com/docs/v4.4/reference/replica-states/#replica-set-member-states
const status = rs.status();

// Extract the state for each member
const memberStates = status.members.map(member => member.state);

// Print the member states
print("Member State:");
memberStates.forEach((state, index) => {
    print(`Member ${index + 1}: ${state}`);
});
```

# Disk commands
```bash
df -aTh

## 1. **`df`**: This is the main command, which stands for "disk free." It retrieves information about file system disk space usage.
## 2. **`-a`**: The `-a` option instructs `df` to display all file systems, including those with zero block sizes. Essentially, it shows information for all mounted file systems, even if they are empty or not in use.
## 3. **`-T`**: The `-T` option adds a column to the output that indicates the file system type (e.g., ext4, nfs, tmpfs, etc.). It helps you identify the type of each mounted file system.
## 4. **`-h`**: The `-h` option makes the output human-readable by displaying sizes in a more understandable format (e.g., KB, MB, GB) rather than raw bytes.
## ```


# Redis

```bash
##// Redis
acl genpass

acl setuser default >cf4955ed403d6b266d84aa1a3fcf47cbf6f3bb9ed056f797eea64c0f02e769f7 on sanitize-payload allchannels allkeys +@all
acl setuser default > on allchannels allkeys +@all

acl setuser i4682 >9948a4026b6af70514f0d520ef686c3a142b4d0b618eef14eced2508dcc0f204 on allchannels allkeys +@all

acl setuser tyk_usr >93ad5f8d7860143c253caa15ac98e5708080034b50a660a79977d77ae1be180d on allchannels allkeys +@all

acl setuser prometheus_usr >70718d85a5538e2bdf20ba821bf04ae9ac1838e3f352a1e634382fee7a209a15 ~* +get
acl setuser prometheus_usr >70718d85a5538e2bdf20ba821bf04ae9ac1838e3f352a1e634382fee7a209a15 on allchannels allkeys +@all


redis-cli ACL DELUSER prometheus_user

sudo vi /etc/users.acl

acl setuser prometheus_usr on #b88df0c13d08a252a5988e0b995ae6cd807f7190f102da89655bc559777e1707 ~* &* -@all +get

acl setuser prometheus_usr >70718d85a5538e2bdf20ba821bf04ae9ac1838e3f352a1e634382fee7a209a15 on allchannels allkeys +@all

acl setuser prometheus_usr >VVJX/JfSD0!AP0 on allchannels allkeys +@all

find / -name go 2> /dev/null


sudo mkdir -p $HOME/go/{bin,src,pkg}
sudo export GOPATH=/go
sudo export PATH=${PATH}:${GOPATH}/bin:/usr/local/go/bin

##REDIS
sudo touch /etc/systemd/system/redis_exporter.service
sudo chmod 664 /etc/systemd/system/redis_exporter.service
sudo vi /etc/systemd/system/redis_exporter.service

sudo systemctl daemon-reload

sudo systemctl start redis_exporter

sudo systemctl enable redis_exporter

sudo systemctl status redis_exporter

(code=exited, status=2)
sudo journalctl -u redis_exporter.service

sudo tail -f /var/log/redis/redis-server.log

sudo find / -name *redis-server*

acl setuser tyk_usr >93ad5f8d7860143c253caa15ac98e5708080034b50a660a79977d77ae1be180d on allchannels allkeys +@all

acl setuser prometheus_usr >VVJX/JfSD0!AP0 on allchannels allkeys +@all

acl setuser adm_i4682 >9948a4026b6af70514f0d520ef686c3a142b4d0b618eef14eced2508dcc0f204 on allchannels allkeys +@all

user adm_i4682 on #9c5bdefe3ab8b10948471dd96ada474fec46a5a501d000472f20960f7a4f486a ~* &* +@all
user default on nopass ~* &* +@all
user prometheus_usr on #927646c22893ecc1dc07c45132d9dd9c9a43adf248caa3fad01cd613bbf49526 ~* &* +@all
user tyk_usr on #f1ced2595880302c4f1b62b8880537d8d6134768b1fce8d17ad8450e375c01cc ~* &* +@all

```