# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.box = "centos/7"
  config.hostmanager.enabled = true
  config.hostmanager.include_offline = true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "3072"
    vb.cpus = 2
  end

  NodeCount = 3

  # Kafka Nodes
  (1..NodeCount).each do |i|
    config.vm.define "broker#{i}" do |c|
      c.vm.hostname = "broker#{i}"
      c.vm.network "private_network", ip: "192.168.0.1#{i}"
      c.vm.provision "bootstrap", type:"ansible" do |ansible|
        ansible.playbook = "bootstrap.yml"
      end
      c.vm.provision "kafka", type:"ansible" do |ansible|
        ansible.playbook = "kafka.yml"
      end
      c.vm.provision "zookeeper", type:"ansible" do |ansible|
        ansible.playbook = "zookeeper.yml"
      end
    end
  end

  config.vm.provision "shell", path: "bootstrap.sh"

end
