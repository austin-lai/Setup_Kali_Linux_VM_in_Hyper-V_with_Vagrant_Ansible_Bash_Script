
# Setup Kali Linux VM in Hyper-V with Vagrant and Ansible and Bash Script

```markdown
> Austin.Lai |
> -----------| December 10th, 2023
> -----------| Updated on December 10th, 2023
```

---

## Table of Contents

<!-- TOC -->

- [Setup Kali Linux VM with Vagrant and Ansible and Bash Script](#setup-kali-linux-vm-with-vagrant-and-ansible-and-bash-script)
    - [Table of Contents](#table-of-contents)
    - [Disclaimer](#disclaimer)
    - [Description](#description)
    - [Vagrantfile](#vagrantfile)
        - [Ansible Playbook](#ansible-playbook)

<!-- /TOC -->

<br>

## Disclaimer

<span style="color: red; font-weight: bold;">DISCLAIMER:</span>

This project/repository is provided "as is" and without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.

This project/repository is for <span style="color: red; font-weight: bold;">Educational</span> purpose <span style="color: red; font-weight: bold;">ONLY</span>. Do not use it without permission. The usual disclaimer applies, especially the fact that me (Austin) is not liable for any damages caused by direct or indirect use of the information or functionality provided by these programs. The author or any Internet provider bears NO responsibility for content or misuse of these programs or any derivatives thereof. By using these programs you accept the fact that any damage (data loss, system crash, system compromise, etc.) caused by the use of these programs is not Austin responsibility.

<br>

## Description

<!-- Description -->

Setup Kali Linux VM with Vagrant, Ansible, and Bash Script.

The Vagrantfile, Ansible Playbook and configuration provide very basic configuration, you may modified to suit your environment.

You may also convert [init script from Setup Kali Linux VM in Hyper-V](https://github.com/austin-lai/Setup_Kali_Linux_VM_in_Hyper-V) into Ansible Playbook or direct use with Vagrantfile.

Below are some useful vagrant plugins you can use:

- vagrant plugin install vagrant-share
- vagrant plugin install vagrant-sshfs
- vagrant plugin install vagrant-dns
- vagrant plugin install vagrant-host-shell
- vagrant plugin install vagrant-host-path
- vagrant plugin install vagrant-ip-show
- vagrant plugin install vagrant-compose

<!-- /Description -->

<br>

## Vagrantfile

The `Vagrantfile` file can be found [here](./Vagrantfile) or below:

<details>

<summary><span style="padding-left:10px;">Click here to expand for the "Vagrantfile" !!!</span></summary>

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["LC_ALL"] = "en_US.UTF-8"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.3.5"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # Give a custom name to your Vagrant machine
  config.vm.define "kali-box" do |machine|

    # The most common configuration options are documented and commented below.
    # For a complete reference, please see the online documentation at
    # https://docs.vagrantup.com.

    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://vagrantcloud.com/search.
    machine.vm.box = "kalilinux/rolling"

    machine.vm.hostname = "kali-box"

    machine.vm.allow_hosts_modification = true

    # The communicator type to use to connect to the guest box. By default this is "ssh", but should be changed to "winrm" for Windows guests.
    machine.vm.communicator = "ssh"

    # SSH Configuration
    machine.ssh.username = "vagrant"
    machine.ssh.password = "vagrant"
    machine.ssh.insert_key = false  # Do not insert default Vagrant SSH key

    # Forward SSH Agent (useful for provisioning with private GitHub repositories)
    # machine.ssh.forward_agent = true

    # Customize SSH keys for Windows paths
    # machine.ssh.private_key_path = ""

    # Disable strict host key checking (useful for development)
    machine.ssh.verify_host_key = false

    # (boolean) - If false, this setting will not include the compression setting when ssh'ing into a machine. If this is not set, it will default to true and Compression=yes will be enabled with ssh.
    machine.ssh.compression = true

    # (integer) - Number of seconds to wait for establishing an SSH connection to the guest. Defaults to 15.
    machine.ssh.connect_timeout = 60

    # (boolean) - If true, X11 forwarding over SSH connections is enabled. Defaults to false.
    machine.ssh.forward_x11 = true

    # (integer) - The port on the guest that SSH is running on. This is used by some providers to detect forwarded ports for SSH. For example, if this is set to 22 (the default), and Vagrant detects a forwarded port to port 22 on the guest from port 4567 on the host, Vagrant will attempt to use port 4567 to talk to the guest if there is no other option.
    # machine.ssh.guest_port = 2222

    # (string) - The hostname or IP to SSH into. By default this is empty, because the provider usually figures this out for you.
    # config.ssh.host = 

    # (boolean) - If true, this setting SSH will send keep-alive packets every 5 seconds by default to keep connections alive.
    machine.ssh.keep_alive = true

    # (boolean) - Only use Vagrant-provided SSH private keys (do not use any keys stored in ssh-agent). The default value is true.
    # machine.ssh.keys_only = true

    # (integer) - The port to SSH into. By default this is port 22.
    machine.ssh.port = 22

    # Set the shell for provisioning scripts
    machine.ssh.shell = "bash -l"

    # Additional SSH options
    # machine.ssh.extra_args = ["-A", "-o ForwardX11=yes"]

    # The time in seconds that Vagrant will wait for the machine to gracefully halt when vagrant halt is called. Defaults to 60 seconds.
    machine.vm.graceful_halt_timeout = 60

    machine.vm.boot_timeout = 1200 # 20 minutes
    
    # The guest OS that will be running within this machine. This defaults to :linux, and Vagrant will auto-detect the proper distro. However, this should be changed to :windows for Windows guests. Vagrant needs to know this information to perform some guest OS-specific things such as mounting folders and configuring networks.
    machine.vm.guest = :linux

    # A message to show after vagrant up. This will be shown to the user and is useful for containing instructions such as how to access various components of the development environment.
    machine.vm.post_up_message = "This is the start up message!"

    # Disable automatic box update checking. If you disable this, then
    # boxes will only be checked for updates when the user runs
    # `vagrant box outdated`. This is not recommended.
    # config.vm.box_check_update = false
    machine.vm.box_check_update = true

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    # NOTE: This will enable public access to the opened port
    # config.vm.network "forwarded_port", guest: 80, host: 8080

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine and only allow access
    # via 127.0.0.1 to disable public access
    # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    # config.vm.network "private_network", ip: "192.168.33.10"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # config.vm.network "public_network"
    # config.vm.network "public_network", ip: "192.168.0.1", hostname: true # Network specified with `:hostname` must provide a static ip
    machine.vm.network "public_network", bridge: "Default Switch"

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    # config.vm.synced_folder '/host/path', '/guest/path', type: "smb", mount_options: ['mfsymlink']
    # This option may be globally disabled with an environment variable:
    # VAGRANT_DISABLE_SMBMFSYMLINKS=1

    # Disable the default share of the current code directory. Doing this
    # provides improved isolation between the vagrant box and your host
    # by making sure your Vagrantfile isn't accessable to the vagrant box.
    config.vm.synced_folder ".", "/vagrant", disabled: true

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    machine.vm.provider "hyperv" do |hv|
        
      hv.vmname = "kali-box"

      hv.memory = 2048
      
      hv.maxmemory = 2048
      
      hv.cpus = 2

      hv.enable_enhanced_session_mode = true

      hv.enable_checkpoints = true
      
      hv.enable_automatic_checkpoints = true
    
      # Enable virtualization extensions for the virtual CPUs
      hv.enable_virtualization_extensions = true

      hv.linked_clone = true

      # Enable VM integration services (e.g., Copy-VMFile)
      hv.vm_integration_services = {
        guest_service_interface: true, # This line enables Copy-VMFile
        heartbeat: true,
        key_value_pair_exchange: true,
        shutdown: true,
        time_synchronization: true,
        vss: true,
      }

      hv.auto_start_action = "StartIfRunning" # (Nothing, StartIfRunning, Start) - Automatic start action for VM on host startup.

      hv.auto_stop_action =  "ShutDown" # (ShutDown, TurnOff, Save) - Automatic stop action for VM on host shutdown. Default: ShutDown.

      # hv.customize  ["virtual_switch", { type: "External", name: "External Switch", :adapter => "Ethernet" }]
      
    end

    # Enable provisioning with a shell script. Additional provisioners such as
    # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
    # documentation for more information about their specific syntax and use.
    ############################
    # config.vm.provision "shell", inline: <<-SHELL
    #   apt-get update
    #   apt-get install -y apache2
    # SHELL
    ####### OR #######
    # $script = <<-SCRIPT
    # echo I am provisioning...
    # date > /etc/vagrant_provisioned_at
    # SCRIPT

    # Vagrant.configure("2") do |config|
    #   config.vm.provision "shell", inline: $script
    # end
    ####### OR #######
    # $script = <<-'SCRIPT'
    # echo "These are my \"quotes\"! I am provisioning my guest."
    # date > /etc/vagrant_provisioned_at
    # SCRIPT

    # Vagrant.configure("2") do |config|
    #   config.vm.provision "shell", inline: $script
    # end
    ####### OR #######
    # config.vm.provision "shell", path: "init.sh"
    # config.vm.provision "shell", path: "https://example.com/provisioner.sh"
    ##############


    
    # Use :ansible or :ansible_local to
    # select the provisioner of your choice
    config.vm.provision :ansible do |ansible|
      ansible.playbook = "playbook.yml"
      ansible.install_mode = "pip"
    end
  end
end
```

</details>

<br>

### Ansible Playbook

Sample of Ansible Playbook can be found [here](./playbook.yml) or below:

```yml
---
- name: Configure Kali Linux VM
  hosts: localhost
  become: yes
  tasks:
    - name: Print message
      command: echo -e "\nYou have selected 'set-terminal'\n"

    - name: Display completion message
      debug:
        msg: "Upgrade completed."
```
