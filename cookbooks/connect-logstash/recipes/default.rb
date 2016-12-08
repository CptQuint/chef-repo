#
# Cookbook Name:: connect-logstash
# Recipe:: default
#
# Copyright 2016, Connect Distribution Services Ltd.
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "/etc/yum.repos.d/logstash.repo" do
  source "logstash.repo"
  mode "0644"
end

include_recipe "yum"

package 'logstash' do
  action :install
end

service 'logstash' do
  action [ :enable, :start ]
end
