default['discourse']['directory'] = '/var/discourse'
default['discourse']['git']['remote'] = 'https://github.com/discourse/discourse_docker.git'
default['discourse']['git']['branch'] = 'master'
default['discourse']['rebuild'] = false

# Configure the discourse docker template
default['discourse']['port'] = 80
default['discourse']['ssh_port'] = 2222
default['discourse']['language'] = 'en_US.UTF-8'
default['discourse']['developer_emails'] = []
default['discourse']['hostname'] = 'discourse.local'
default['discourse']['smtp']['hostname'] = 'localhost'
default['discourse']['smtp']['port'] = '587'
default['discourse']['smtp']['user'] = ''
default['discourse']['smtp']['password'] = ''
default['discourse']['smtp']['start_tls'] = true
