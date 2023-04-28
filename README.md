
# vagrant-kafka

## Vagrantfile for provisioning a Kafka cluster with 3 brokers and 3 zookeepers

### Requirements

* Vagrant + vagrant-hostmanager plugin

```bash
vagrant plugin install vagrant-hostmanager
```

* VirtualBox

Usage

* Clone this repository
* Edit the `Vagrantfile` with the recources you want to allocate to the VMs
* Run `vagrant up`
* Check VMs status with `vagrant status` (you should see something like this)

```bash
Current machine states:

broker1                   running (virtualbox)
broker2                   running (virtualbox)
broker3                   running (virtualbox)
```

* Configure Kafka on every node (this procedure should be done on every node)

```bash
vagrant ssh broker{1..3}
sudo su -
```
```bash
vi /etc/systemd/system/zookeeper.service
```

Add the following content:

```bash
[Unit]
Description=Zookeeper Daemon
Documentation=http://zookeeper.apache.org
Requires=network.target
After=network.target

[Service]
Type=forking
WorkingDirectory=/opt/zookeeper
User=zookeeper
Group=zookeeper
ExecStart=/opt/zookeeper/bin/zkServer.sh start /opt/zookeeper/conf/zoo.cfg
ExecStop=/opt/zookeeper/bin/zkServer.sh stop /opt/zookeeper/conf/zoo.cfg
ExecReload=/opt/zookeeper/bin/zkServer.sh restart /opt/zookeeper/conf/zoo.cfg
TimeoutSec=30
Restart=on-failure

[Install]
WantedBy=default.target
```

```bash
 vi /etc/systemd/system/kafka.service
```

Add the following content:

```bash
[Unit]
Description=Apache Kafka server (broker)
Documentation=http://kafka.apache.org/documentation.html
Requires=network.target remote-fs.target
After=network.target remote-fs.target zookeeper.service

[Service]
Type=simple
User=kafka
Group=kafka
ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
ExecStop=/opt/kafka/bin/kafka-server-stop.sh

[Install]
WantedBy=multi-user.target
````

```bash
mv /opt/kafka/config/server.properties /opt/kafka/config/server.properties.original

vi /opt/kafka/config/server.properties
```

Add the following content:

```bash
broker.id={1..3}
advertised.listeners=PLAINTEXT://kafka{1..3}:9092
delete.topic.enable=true
log.dirs=/kafka
num.partitions=8
default.replication.factor=3
min.insync.replicas=2
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
zookeeper.connect=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka
zookeeper.connection.timeout.ms=6000
auto.create.topics.enable=true
```

Add the id to the `myid` file (replace `ID` with the broker number 1, 2 or 3)
```bash
echo "ID" > /zookeeper/myid
```

```bash
vi /opt/zookeeper/conf/zoo.cfg
```

Add the following content:

```bash
dataDir=/zookeeper
clientPort=2181
maxClientCnxns=0
tickTime=2000
initLimit=10
syncLimit=5
server.1=zookeeper1:2888:3888
server.2=zookeeper2:2888:3888
server.3=zookeeper3:2888:3888
```

```bash
systemctl enable zookeeper.service
systemctl start  zookeeper.service
systemctl status zookeeper.service

systemctl enable kafka.service
systemctl start  kafka.service
systemctl status kafka.service
```

Reboot the VM

```bash
reboot
```

# Client setup

### WIP