#
# Cookbook Name:: connect-logstash
# Recipe:: default
#
# Copyright 2016, Connect Distribution Services Ltd.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum"
include_recipe "java::oracle"

# add the Elasticsearch repository
yum_repository 'elasticsearch' do
  description "Elasticsearch repository for 5.x packages"
  baseurl "https://artifacts.elastic.co/packages/5.x/yum"
  gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
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
  command "/usr/bin/openssl req -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/#{node[:fqdn]}.key -out certs/#{node[:fqdn]}.crt"
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
