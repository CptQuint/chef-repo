name "elasticsearch_server"
description "A role to configure Connect House Elasticsearch servers"
run_list "recipe[yum]", "recipe[java::oracle]", "recipe[connect-elasticsearch]"
default_attributes( "java" => { "install_flavor" => "oracle", "jdk_version" => "8", "oracle" => { "accept_oracle_download_terms" => true } } )
