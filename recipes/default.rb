#
# Cookbook:: test
# Recipe:: default
puts node.default
package 'install docker' do
    package_name 'docker'
end

file '/etc/docker/daemon.json' do
    owner 'root'
    group 'root'
    mode '644'
    content "{ \"insecure-registries\" : [\"#{node['test']['address']}\"] }"
    action :create
end
service 'docker' do
    supports :status => true, :restart => true, :start => true
    action [ :start ]
end
# Copyright:: 2018, The Authors, All Rights Reserved.
