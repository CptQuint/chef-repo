name "logstash_server"
description "A role to configure Connect House Logstash servers"
run_list "recipe[yum]", "recipe[java::oracle]", "recipe[connect-logstash]"
default_attributes( "java" => { "install_flavor" => "oracle", "jdk_version" => "8", "oracle" => { "accept_oracle_download_terms" => true } } )
default_attributes( :java => { :oracle => { "accept_oracle_download_terms" => true } } { :jdk_version => { "7" } } )
