Vagrant.configure("2") do |config|
  config.vm.define "free5gc-in-a-box"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 8192
    vb.cpus = 4
  end

  config.vm.hostname = "free5gc"
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 38412, host: 38412
  config.vm.network "forwarded_port", guest: 2152, host: 2152
  config.vm.synced_folder "shared", "/config", disabled: false
  
  config.vm.provision "shell", path: "pre-config.sh"
  config.vm.provision :reload
  config.vm.provision "shell", path: "post-config.sh"

end
