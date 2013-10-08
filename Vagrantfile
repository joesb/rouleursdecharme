Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "centos-oxfam"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://packages.vstone.eu/vagrant-boxes/centos/6.3/centos-6.3-64bit-puppet-vbox.4.1.18.box"

  # Host-only network
  config.vm.network :private_network, ip: "192.168.30.20"

  # forward the webserver port 
  config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true
  # and solr port 
  # config.vm.network :forwarded_port, guest: 8180, host: 8001, auto_correct: true
  
  # Main vagrant share folder, not the root of this directory as normal
  # config.vm.synced_folder "./vagrant", "/vagrant", :nfs => false
  config.vm.synced_folder "./deployment", "/vagrant/deployment", :nfs => false
  
  # Mount sites as NFS drives
  config.vm.synced_folder "./webapp", "/var/www/webapp", :nfs=> true

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # bump the memory and cpu allocation
  config.vm.provider :virtualbox do |vb|
    vb.customize [ "modifyvm", :id, "--memory", "2048", "--cpus", "2", "--cpuexecutioncap", "50" ]
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "deployment/manifests"
    puppet.manifest_file  = "dev.pp"
    puppet.module_path = "deployment/modules"
  end

end