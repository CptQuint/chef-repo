#
# Cookbook Name:: connect-logstash
# Recipe:: default
#
# Copyright 2016, Connect Distribution Services Ltd.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum"

# add the Logstash repository
yum_repository 'logstash' do
  description "Logstash repository for 2.2 packages"
  baseurl "http://packages.elasticsearch.org/logstash/2.2/centos"
  gpgkey 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch'
  action :create
end

package 'logstash' do
  action :install
end

service 'logstash' do
  action [ :enable, :start ]
end

execute 'cert_gen' do
  cwd  '/etc/pki/tls'
  command "/usr/bin/openssl req -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/fqdn #{node[:fqdn]}.key -out certs/fqdn #{node[:fqdn]}.crt"
end

template "02-beats-input.conf" do
  path "/etc/logstash/conf.d/02-beats-input.conf"
  source "02-beats-input.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

cookbook_file "/etc/logstash/conf.d/10-syslog-filter.conf" do
  source "10-syslog-filter.conf"
  mode "0644"
end

cookbook_file "/etc/logstash/conf.d/30-elasticsearch-output.conf" do
  source "30-elasticsearch-output.conf"
  mode "0644"
  notifies :restart, resources(:service => "logstash")
end
