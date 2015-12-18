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

git node['discourse']['directory'] do
  #checkout_branch node['discourse']['git']['branch']
  repository node['discourse']['git']['remote']
  action :sync
end

cookbook_file '/root/.ssh/discourse_key' do
  source 'discourse_key'
  mode '0600'
  action :create
end

cookbook_file '/root/.ssh/discourse_key.pub' do
  source 'discourse_key.pub'
  mode '0600'
  action :create
end

# Gets called when template is updated
execute 'bootstrap_discourse' do
  command './launcher stop app; ./launcher bootstrap app'
  cwd node['discourse']['directory']
  action :run
  creates '/var/discourse/shared/standalone'
end

# Gets called when template is updated
execute 'rebuild_discourse' do
  command './launcher rebuild app'
  cwd node['discourse']['directory']
  action :nothing
end

template '/var/discourse/containers/app.yml' do
  source 'app.yml.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables({settings: node['discourse']})
  action :create
  notifies :run, 'execute[rebuild_discourse]', :immediately
end

execute 'run_discourse' do
  command './launcher start app'
  action :run
  cwd node['discourse']['directory']
  not_if do
    docker_command = Mixlib::ShellOut.new('docker ps | grep app')
    docker_command.run_command.exitstatus == 0
  end
end
