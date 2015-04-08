Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: "echo Setting up Geeksoc Testing VMs"

  config.vm.define "ldap" do |ldap|
    ldap.vm.box = "puppetlabs/debian-7.8-64-puppet"

    ldap.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet_manifests"
      puppet.manifest_file = "ldap.pp"
      puppet.module_path = "puppet_modules"
    end
    ldap.vm.network "forwarded_port", guest: 80, host: 1234
    ldap.vm.network "forwarded_port", guest: 389, host: 1389
  end
end
