# -*- mode: ruby -*-
# vi: set ft=ruby :

# Execute this Vagrantfile with elevated and privileged (!!)


# Vagrant.require_version ">= 1.3.5"

# ENV["LC_ALL"] = "en_US.UTF-8"


# Global variables - ssh key and a box that should be used for the servers
# ssh_key                     = "~/.ssh/id_rsa"
ssh_key                     = "C:/austin-tools/kali-hyper-v-id_rsa"
box                         = "kalilinux/rolling"

# Define servers details.
# Mandatory variables:
# - hostname
# - ip (possible arguments - static ip or dhcp - "10.10.10.10"/"dhcp")
# Optional variables, could be set to override the defaults for specific box:
# - ram (default: 512)
# - cpu (default: 1)
# - box (default: defined above)
# - port_guest and port_host (port forwarding - not defined by default)
# - folder_guest and folder_host (synced folders - not defined by default)
servers = [
#   { :hostname => "server1", :ip => "10.10.10.10", :ram => 1024, :cpu => 2, :group => "servers" },
#   { :hostname => "client3", :ip => "dhcp", :group => "clients" }
  { :hostname => "kali-box", :ip => "dhcp", :ram => 2048, :cpu => 2, :group => "attacker" }
]

# Defined ansible playbook
# If empty, will skip the ansible provisioner block
# ansible_playbook = "playbook.yml"
ansible_playbook = ""

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# All Vagrant configuration is done below. The "2" in Vagrant.Configures the configuration version (we support older styles for backwards compatibility). Please don't change it unless you know what you're doing.
# Vagrant.configure("2") do |config|
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # if Vagrant.has_plugin?("plugin-name")
    #     # Plugin is installed
    #     puts "Plugin is installed"
    # else
    #     # Plugin is not installed
    #     puts "Plugin is not installed"
    #     system("vagrant plugin install plugin-name")
    # end

    # Check if vagrant-share Plugin is installed
    if Vagrant.has_plugin?("vagrant-share")
        # Plugin is installed
        puts "vagrant-share Plugin is installed"
    else
        # Plugin is not installed
        puts "vagrant-share Plugin is not installed"
        # system("vagrant plugin install vagrant-share")
    end

    # Check if vagrant-sshfs Plugin is installed
    if Vagrant.has_plugin?("vagrant-sshfs")
        # Plugin is installed
        puts "vagrant-sshfs Plugin is installed"
    else
        # Plugin is not installed
        puts "vagrant-sshfs Plugin is not installed"
        # system("vagrant plugin install vagrant-sshfs")
    end

    # Check if vagrant-dns Plugin is installed
    if Vagrant.has_plugin?("vagrant-dns")
        # Plugin is installed
        puts "vagrant-dns Plugin is installed"
    else
        # Plugin is not installed
        puts "vagrant-dns Plugin is not installed"
        # system("vagrant plugin install vagrant-dns")
    end

    # Check if vagrant-host-shell Plugin is installed
    if Vagrant.has_plugin?("vagrant-host-shell")
        # Plugin is installed
        puts "vagrant-host-shell Plugin is installed"
    else
        # Plugin is not installed
        puts "vagrant-host-shell Plugin is not installed"
        # system("vagrant plugin install vagrant-host-shell")
    end

    # Check if vagrant-host-path Plugin is installed
    if Vagrant.has_plugin?("vagrant-host-path")
        # Plugin is installed
        puts "vagrant-host-path Plugin is installed"
    else
        # Plugin is not installed
        puts "vagrant-host-path Plugin is not installed"
        # system("vagrant plugin install vagrant-host-path")
    end

    # Check if vagrant-ip-show Plugin is installed
    if Vagrant.has_plugin?("vagrant-ip-show")
        # Plugin is installed
        puts "vagrant-ip-show Plugin is installed"
    else
        # Plugin is not installed
        puts "vagrant-ip-show Plugin is not installed"
        # system("vagrant plugin install vagrant-ip-show")
    end

    # Check if vagrant-compose Plugin is installed
    if Vagrant.has_plugin?("vagrant-compose")
        # Plugin is installed
        puts "vagrant-compose Plugin is installed"
    else
        # Plugin is not installed
        puts "vagrant-compose Plugin is not installed"
        # system("vagrant plugin install vagrant-compose")
    end


    # Use of the hostmanager plugin to update the host and guest /etc/hosts file.
    if Vagrant.has_plugin?("vagrant-hostmanager")
        # Plugin is installed
        puts "vagrant-hostmanager Plugin is installed"

        config.hostmanager.enabled = true
        config.hostmanager.manage_host = true
        config.hostmanager.manage_guest = true
        config.hostmanager.ignore_private_ip = false
        config.hostmanager.include_offline = false

        # Resolve dynamic ip address (dhcp) of the host and guests for the /etc/hosts file.
        # https://github.com/devopsgroup-io/vagrant-hostmanager/issues/86
        servers.each do |server|
            if server[:ip] == "dhcp"
                cached_addresses = {}
                config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
                    if cached_addresses[vm.name].nil?
                        if hostname = (vm.ssh_info && vm.ssh_info[:host])
                            vm.communicate.execute("hostname -I | cut -d ' ' -f 2") do |type, contents|
                                cached_addresses[vm.name] = contents.split("\\n").first[/(\\d+\\.\\d+\\.\\d+\\.\\d+)/, 1]
                            end
                        end
                    end
                    cached_addresses[vm.name]
                end
            end
        end
    else
        # Plugin is not installed
        puts "vagrant-hostmanager Plugin is not installed"
        puts "Installing vagrant-hostmanager Plugin..."
        system("vagrant plugin install vagrant-hostmanager")
    end


    # Create groups to be used in ansible inventory
    groups = {"all" => []}
    servers.each do |cfg|
        if ! groups.has_key?(cfg[:group])
            groups[cfg[:group]] = [cfg[:hostname]]
        else
            groups[cfg[:group]].push(cfg[:hostname])
        end

        groups["all"].push(cfg[:hostname])
    end


    # Loop and create each server from the servers array above.
    servers.each_with_index do |server, index|
      # Check if custom box is defined for specific server within the servers array.
      # If not applies the default (box=ubuntu/xenial64).
      box_image = server[:box] ? server[:box] : box;
      config.vm.define server[:hostname] do |conf|
        conf.vm.box = box_image.to_s
        conf.vm.hostname = server[:hostname]
        conf.vm.network "public_network", bridge: "Default Switch"

        # Set synced folders if defined
        if !server[:folder_guest].nil? && !server[:folder_host].nil?
          conf.vm.synced_folder server[:folder_host], server[:folder_guest]
        else
          conf.vm.synced_folder ".", "/vagrant", disabled: true
        end
        
        
        # Checks for the custom cpu and/or ram defined for a specific server.
        # If not applies the default (cpu=2, ram=2048).
        cpu = server[:cpu] ? server[:cpu] : 2;
        memory = server[:ram] ? server[:ram] : 2048;
        config.vm.provider "hyperv" do |hv|

            # hv.vmname = "kali-box"
            hv.vmname = server[:hostname]

            hv.memory = memory.to_s
            hv.maxmemory = 2048
            hv.cpus = cpu.to_s
            hv.enable_enhanced_session_mode = true
            hv.enable_checkpoints = true
            hv.enable_automatic_checkpoints = true
            hv.linked_clone = true

            # Enable virtualization extensions for the virtual CPUs
            hv.enable_virtualization_extensions = true

            # Enable VM integration services (e.g., Copy-VMFile)
            hv.vm_integration_services = {
                guest_service_interface: true, # This line enables Copy-VMFile
                heartbeat: true,
                key_value_pair_exchange: true,
                shutdown: true,
                time_synchronization: true,
                vss: true,
            }

            # hv.auto_start_action = "StartIfRunning" # (Nothing, StartIfRunning, Start) - Automatic start action for VM on host startup.
            hv.auto_start_action = "Nothing" # (Nothing, StartIfRunning, Start) - Automatic start action for VM on host startup.

            hv.auto_stop_action =  "ShutDown" # (ShutDown, TurnOff, Save) - Automatic stop action for VM on host shutdown. Default: ShutDown.

            # hv.customize  ["virtual_switch", { type: "External", name: "External Switch", :adapter => "Ethernet" }]

        end

        # The communicator type to use to connect to the guest box. By default this is "ssh", but should be changed to "winrm" for Windows guests.
        conf.vm.communicator = "ssh"
        # Takes the ssh key provided above and copying the public key to the server.
        conf.ssh.private_key_path = ["~/.vagrant.d/insecure_private_key", ssh_key]
        # conf.ssh.private_key_path = "C:/austin-tools/kali-hyper-v-id_rsa"
        conf.ssh.insert_key = false
        conf.vm.provision "file", source: ssh_key + ".pub", destination: "~/.ssh/authorized_keys"
        conf.ssh.username = "vagrant"
        conf.ssh.password = "vagrant"
        conf.ssh.forward_agent = true
        conf.ssh.verify_host_key = false
        conf.ssh.compression = true
        conf.ssh.connect_timeout = 60
        conf.ssh.forward_x11 = true
        conf.ssh.keep_alive = true
        # (integer) - The port on the guest that SSH is running on. This is used by some providers to detect forwarded ports for SSH. For example, if this is set to 22 (the default), and Vagrant detects a forwarded port to port 22 on the guest from port 4567 on the host, Vagrant will attempt to use port 4567 to talk to the guest if there is no other option.
        # conf.ssh.guest_port = 2222
        # (string) - The hostname or IP to SSH into. By default this is empty, because the provider usually figures this out for you.
        # config.ssh.host = 
        # (boolean) - Only use Vagrant-provided SSH private keys (do not use any keys stored in ssh-agent). The default value is true.
        # conf.ssh.keys_only = true
        # (integer) - The port to SSH into. By default this is port 22.
        # conf.ssh.port = 22
        # Set the shell for provisioning scripts
        # conf.ssh.shell = "bash -l"
        # Additional SSH options
        # conf.ssh.extra_args = ["-A", "-o ForwardX11=yes"]


        # The time in seconds that Vagrant will wait for the machine to gracefully halt when vagrant halt is called. Defaults to 60 seconds.
        conf.vm.graceful_halt_timeout = 10

        conf.vm.boot_timeout = 30 # 30 seconds
        
        # The guest OS that will be running within this machine. This defaults to :linux, and Vagrant will auto-detect the proper distro. However, this should be changed to :windows for Windows guests. Vagrant needs to know this information to perform some guest OS-specific things such as mounting folders and configuring networks.
        conf.vm.guest = :linux

        # A message to show after vagrant up. This will be shown to the user and is useful for containing instructions such as how to access various components of the development environment.
        conf.vm.post_up_message = "This is the start up message!"

        # Disable automatic box update checking. If you disable this, then
        # boxes will only be checked for updates when the user runs
        # `vagrant box outdated`. This is not recommended.
        # config.vm.box_check_update = false
        conf.vm.box_check_update = true


        # The ubuntu/xenial64 box is missing python. Install it for ansible provision.
        if box_image == "kalilinux/rolling"
          conf.vm.provision "shell" do |s|
            # s.inline = "test -e /usr/bin/python || (update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 && locale-gen en_US en_US.UTF-8 && apt-get -qqy update && apt-get install -qqy python-minimal ansible)"
            s.inline = "apt-get -qqy update"
          end
        end


        # Provision nodes with Ansible.
        # The index used here in order to execute the provision just after all
        # the servers are up and running.
        if index == servers.size - 1
          if ansible_playbook != ""
            conf.vm.provision :ansible do |ansible|
              ansible.verbose = "v"
              ansible.limit = "all"
              ansible.groups = groups
              ansible.playbook = ansible_playbook
            end
          end
        end


        # WORKAROUND for all LIMITATIONS OF VAGRANT (execute a powershell script to handle hyper-v actions before startup of instance)
        # will be executed before the hyper-Instance will be started  
        secSwitch = 'Hyper-V-Lab_Private'
        conf.trigger.before :'VagrantPlugins::HyperV::Action::StartInstance', type: :action do |trigger|
            trigger.name = "Changing Hyper-V VM network switch"
            trigger.run = { inline: "./hyperv-config-node.ps1 -VmName kali-box -SwitchName \"'#{secSwitch}'\" " }
        end
        ########## OR ##########
        # conf.trigger.before :reload do |trigger|
        # conf.trigger.after :up do |trigger|
        #   trigger.name = "Changing Hyper-V VM network switch"
        #   trigger.run = {inline: "./hyperv-config-node.ps1"}
        # end

        conf.trigger.after :up do |trigger|
            trigger.name = "Setting up network interface"
            trigger.run = {inline: "bash config_eth0.sh"}
        end
  
        conf.trigger.after :up do |trigger|
            trigger.name = "Finished Message ! INSIDE >> config.vm.define \"kali-box\" do |machine| <<"
            trigger.warn = "Finished Message ! INSIDE >> config.vm.define \"kali-box\" do |machine| <<"
            trigger.info = "Finally Machine is up ! INSIDE >> config.vm.define \"kali-box\" do |machine| <<"
        end


        # ####################################################
        # Vagrant.configure("2") do |config|
        #   config.vm.provision "shell", inline: $script
        # end
        # ###### OR #######
        # $script = <<-'SCRIPT'
        # echo "These are my \"quotes\"! I am provisioning my guest."
        # date > /etc/vagrant_provisioned_at
        # SCRIPT
        # ####################################################
        # Vagrant.configure("2") do |config|
        #   config.vm.provision "shell", inline: $script
        # end
        # ###### OR #######
        # config.vm.provision "shell", path: "init.sh"
        # config.vm.provision "shell", path: "https://example.com/provisioner.sh"
        # ####################################################
        # Single Command Trigger
        # conf.trigger.after :up do |trigger|
        #   ...
        # end
        # # multiple commands for this trigger
        # conf.trigger.before [:up, :destroy, :halt, :package] do |trigger|
        #   ...
        # end
        # # or defined as a splat list
        # conf.trigger.before :up, :destroy, :halt, :package do |trigger|
        #   ...
        # end
        # ####################################################


      end


    end


end
