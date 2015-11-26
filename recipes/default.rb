#
# Cookbook Name:: discourse_docker
# Recipe:: default
#

# Install discourse after docker

#mkdir /var/discourse
#git clone https://github.com/discourse/discourse_docker.git /var/discourse
#cd /var/discourse

#cp samples/standalone.yml containers/app.yml

#./launcher bootstrap app
#./launcher start app

execute 'create_ssh_key' do
  command 'ssh-keygen -b 1024 -t rsa -N "" -C "Disourse access key" -f /root/.ssh/discourse;' +
          'cat /root/.ssh/discourse.pub >> /root/.ssh/authorized_keys'
  action :run
  cwd '/root'
  creates '/root/.ssh/discourse'
end

git node['discourse']['directory'] do
  checkout_branch node['discourse']['git']['branch']
  repository node['discourse']['git']['remote']
  action :sync
end

template '/var/discourse/containers/app.yml' do
  source 'app.yml.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables({settings: node['discourse']})
end

execute 'bootstrap_discourse' do
  command './launcher bootstrap app'
  action :run
  cwd node['discourse']['directory']
  creates '/var/discourse/shared/standalone'
end

execute 'run_discourse' do
  command './launcher start app'
  action :run
  cwd node['discourse']['directory']
  not_if { Mixlib::ShellOut.new('docker inspect app').run_command }
end
