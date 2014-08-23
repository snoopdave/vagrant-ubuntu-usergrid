# -*- mode: ruby -*-
# vi: set ft=ruby :

#-------------------------------------------------------------------------------
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#-------------------------------------------------------------------------------

Vagrant.configure(2) do |config|

    #config.vm.box = "precise64"
    #config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    config.vm.box = "trusty64"
    config.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vbox.box"

    config.vm.boot_timeout = 600

    config.vm.provider "virtualbox" do |v|
        v.memory = 2048
    end

    config.vm.define :ug do |ug|
        ug.vm.host_name = "ug"
        ug.vm.network "private_network", ip: "10.1.1.161"
        ug.vm.provision :shell, 
           inline: "/vagrant/bootstrap.sh \"10.1.1.161\" " 
    end

end


