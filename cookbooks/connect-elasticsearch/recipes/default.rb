#
# Cookbook Name:: connect-elasticsearch
# Recipe:: default
#
# Copyright 2016, Connect Distribution Services Ltd.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum"
include_recipe "java::oracle"

cluster_nodes = '["' + search(:node, 'role:elasticsearch_server').map(&:ipaddress).sort.uniq.join('", "') + '"]'

# add the Elasticsearch repository
yum_repository 'elasticsearch' do
  description "Elasticsearch repository for 5.x packages"
  baseurl "https://artifacts.elastic.co/packages/5.x/yum"
  gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
  action :create
end

package 'elasticsearch' do
  action :install
end

service 'elasticsearch' do
  action [ :enable, :start ]
end

#es_node_config_dir = "/etc/elasticsearch/#{node[:hostname]}"

#directory es_node_config_dir do
#  owner "elasticsearch"
#  group "elasticsearch"
#  mode "0755"
#  recursive true
#end

template "elasticsearch.yml" do
  variables(
    'cluster_nodes': cluster_nodes
  )
  path "/etc/elasticsearch/elasticsearch.yml"
  source "elasticsearch.yml.erb"
  owner "elasticsearch"
  group "elasticsearch"
  mode "0644"
  notifies :restart, resources(:service => "elasticsearch")
end
