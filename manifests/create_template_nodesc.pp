sahara_node_group_template { 'test2' :
  ensure => present,
  plugin_name => 'vanilla',
  flavor_id => 'm1.large',
  hadoop_version => '2.4.1',
  auto_security_group => true,
  node_processes => ['datanode', 'nodemanager'], 

  auth_url => "http://192.168.0.4:5000/v2.0/",
  auth_username => "admin",
  auth_password => "admin",
  auth_tenant_name => "admin",
  debug => true,
}

