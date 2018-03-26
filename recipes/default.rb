#
# Cookbook:: dockapp
# Recipe:: default
puts node.default

bash "docker-startup" do
  code <<-EOH
    if netstat -an | egrep ":(8082)" 
    then
      docker run --name greet1 -p 8083:8080 --label port=8083 -d 192.168.0.10:5000/task7:#{node['dockapp']['version']}
      docker stop \$(docker ps --filter label=port=8082 -q)
      sleep 2
      docker rm \$(docker ps -a --filter label=port=8082 -q)
      sleep 2
    else
      docker run --name greet2 -p 8082:8080 --label port=8082 -d 192.168.0.10:5000/task7:#{node['dockapp']['version']}
      docker stop \$(docker ps --filter label=port=8083 -q)
      sleep 2
      docker rm \$(docker ps -a --filter label=port=8083 -q)
      sleep 2
    fi
  EOH
end

# Copyright:: 2018, The Authors, All Rights Reserved.
